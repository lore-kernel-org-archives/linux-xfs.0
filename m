Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6370AC197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 16:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjKTQt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjKTQt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 11:49:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2745BBC
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 08:49:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEB1C433C8;
        Mon, 20 Nov 2023 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700498994;
        bh=spAkoFX5MgCoqomHLsJdwPCMTDLdJ3gZ64I+yiK84Po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lMSIxK8UUQR54N5u1DBS7QwsGUiwOr50aGQSzzXSHxGMKvkh+w+zYO1lwPUuLgjVD
         GpJ3W2WX2E3X1bOj/W9VoL13tS26gQCKchKImcC86KbJbhNkq6AXcVBknQbGYqUjll
         hdBdOS5r/1kGZfDJ4XIlMjBznQbOnCvAMiil0si8PCyWHVcCsF/Cbwjgn7gIClPQaK
         vemftotpNX9uq0oH2iZ+ev81jb38AHxQ5jd7ecWzYkEir0HyZ++T/JTMrc5Aueq4P8
         Jb8xMgMZOpwTy+gQzjVGR+ZZ+a6LUKnZK3d7QnaaluvyCG7f54UMDMsa8JSpIugsOU
         wDuv1JxzofQnw==
Date:   Mon, 20 Nov 2023 08:49:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: Re: [PATCH 2/2] libxfs-apply: Add option to only import patches into
 guilt stack
Message-ID: <20231120164954.GC36190@frogsfrogsfrogs>
References: <20231120151056.710510-1-cem@kernel.org>
 <20231120151056.710510-2-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120151056.710510-2-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 04:10:47PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> The script automatically detects the existence of a guilt stack, but
> only conflict resolution mechanisms so far are either skip the patch or
> fail the process.
> 
> It's easier to fix conflicts if all the patches are stacked in guilt, so
> add an option to stack all the patches into guilt, without applying them,
> for post-processing and conflict resolution in case automatic import fails.
> 
> stgit doesn't seem to have a way to import patches into its stack, so,
> there is no similar patch aiming stgit.

Well... there is a rather gross way to do it, since stg import (even in
--reject mode) is far picker and less aggressive about finding solutions
than regular patch(1):

# Import patch to get the metadata even though it might fail due to
# pickiness.  If the patch applies cleanly, we're done.  Otherwise, set
# up autocleanup for more complicated logic.
stg import --reject "${patch}" && exit 0

tmpfile=/tmp/$$.stgit
trap 'rm -f "${tmpfile}"' TERM INT EXIT QUIT

# Erase whatever stgit managed to apply, then use patch(1)'s more
# flexible heuristics and capture the output.
stg diff | patch -p1 -R
patch -p1 "$@" < "${patch}" > "${tmpfile}" 2>&1
cat "${tmpfile}"

# Attach any new files created by the patch
grep 'create mode' "${patch}" | sed -e 's/^.* mode [0-7]* //g' | while read -r f; do
        git add "$f"
done

# Remove any old files deleted by the patch
grep 'delete mode' "${patch}" | sed -e 's/^.* mode [0-7]* //g' | while read -r f; do
        git rm "$f"
done

# Force us to deal with the rejects.  Use this instead of "<<<" because
# the latter picks up empty output as a single line and does variable
# expansion...  stupid bash.
readarray -t rej_files < <(grep 'saving rejects to' "${tmpfile}" | \
                                sed -e 's/^.*saving rejects to file //g')
rm -f "${tmpfile}"
if [ "${#rej_files[@]}" -gt 0 ]; then
        $VISUAL "${rej_files[@]}"
fi

Once you're done fixing the rejects, 'stg refresh' commits the patch and
you can move on to the next one.

I hadn't thought about merging the above into libxfs-apply directly
though.  I should do that.

Your change for guilt looks ok to me, though I don't have any expertise
with guilt to know if it's good or not.  However, if it makes your life
easier then I say go for it. :)

> The order of commits added to $commit_list also needs to be reversed
> when only importing patches to the guilt stack.
> 
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  tools/libxfs-apply | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index aa2530f4d..2b65684ec 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -9,7 +9,7 @@ usage()
>  	echo $*
>  	echo
>  	echo "Usage:"
> -	echo "	libxfs-apply [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
> +	echo "	libxfs-apply [--import-only] [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
>  	echo "	libxfs-apply --patch <patchfile>"
>  	echo
>  	echo "libxfs-apply should be run in the destination git repository."
> @@ -67,6 +67,7 @@ REPO=
>  PATCH=
>  COMMIT_ID=
>  VERBOSE=
> +IMPORT_ONLY=
>  GUILT=0
>  STGIT=0
>  
> @@ -76,6 +77,7 @@ while [ $# -gt 0 ]; do
>  	--patch)	PATCH=$2; shift ;;
>  	--commit)	COMMIT_ID=$2 ; shift ;;
>  	--sob)		SIGNED_OFF_BY=$2 ; shift ;;
> +	--import-only)	IMPORT_ONLY=true ;;
>  	--verbose)	VERBOSE=true ;;
>  	*)		usage ;;
>  	esac
> @@ -99,6 +101,10 @@ if [ $? -eq 0 ]; then
>  	GUILT=1
>  fi
>  
> +if [ -n $IMPORT_ONLY -a $GUILT -ne 1 ]; then
> +	usage "--import_only can only be used with a guilt stack"
> +fi
> +
>  # Are we using stgit? This works even if no patch is applied.
>  stg top &> /dev/null
>  if [ $? -eq 0 ]; then
> @@ -359,6 +365,11 @@ apply_patch()
>  		fi
>  
>  		guilt import -P $_patch_name $_new_patch.2
> +
> +		if [ -n "$IMPORT_ONLY" ]; then
> +			return;
> +		fi
> +
>  		guilt push
>  		if [ $? -eq 0 ]; then
>  			guilt refresh
> @@ -443,10 +454,17 @@ else
>  	hashr="$hashr -- libxfs"
>  fi
>  
> +# When using --import-only, the commit list should be in reverse order.
> +if [ "$GUILT" -eq 1 -a -n "$IMPORT_ONLY" ]; then
> +	commit_list=`git rev-list --no-merges $hashr`
> +else
> +	commit_list=`git rev-list --no-merges $hashr | tac`

You probably ought to turn this into a proper bash array:

readarray -t commit_list < <(git rev-list --no-merges $hashr | tac)

so that we don't ever run the risk of overflowing line length:

for commit in "${commit_list[@]}"; do
	...
done

Though that's probably only a theoretical concern since ARG_MAX is like
2 million or something.

--D

> +fi
> +
>  # grab and echo the list of commits for confirmation
>  echo "Commits to apply:"
> -commit_list=`git rev-list --no-merges $hashr | tac`
>  git log --oneline --no-merges $hashr |tac
> +
>  read -r -p "Proceed [y|N]? " response
>  if [ -z "$response" -o "$response" != "y" ]; then
>  	fail "Aborted!"
> -- 
> 2.41.0
> 
