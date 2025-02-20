Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6891EBA05
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740074316; cv=none; b=EZeD+3X/rpAbO/RxmRyiUpdPJoT+gUHwIhLj6Sj9RLOlXkhJeG3IcJK6UPgn3nRF3ObmOhzoIelxdFxxfGLhKlav5e2wKAes+IMMonO8BWf0wuKibaA1kNPv4Ya/Am1TnCycQXAva8bvz0NgnCkigSW5+/59ksbjvfHfdNGHWtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740074316; c=relaxed/simple;
	bh=RZljQmKzTZ/pB0iJMJqqsfl3vgjjHi4NrtjGNvI7aI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0F1GCnif/nW/FcGCPtS8SGTZ/+zTSVusTwqdI+cKQCMAXOrvi+j0G7cntLsgw3B8m2POpUisbeeIj6QKz08CnXsNqznavU2uKsGvH+jErS/dLGNRLIkYa3VKoYp/tATT6C1binzQGMs+BBOizM2P9maFGrhT9e3b/R6BPLSvvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZVEbRAUG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZVEbRAUG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740074313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kcz4xAWFqeCC9QetFE4PD7D4V/UBq/8o84kFOzOUJF4=;
	b=ZVEbRAUGbQLLvSHCLBpACttJgZpPiJKlHh04RzJk/kzunL7Elv6L5VfaYDQvdjBm9rG00h
	OtMMlE1A9Z0HNE0N95HKN+WcuMbUiR97Z0ZyRPwQ5YOUOrGDeRnMKHe3siPl/pnyE5mp9P
	c1HhRQJHK+NiTwe/EGnwnYzCFa1WA0U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-bnR8WeZsNUeiVOwHO6FDcw-1; Thu, 20 Feb 2025 12:58:31 -0500
X-MC-Unique: bnR8WeZsNUeiVOwHO6FDcw-1
X-Mimecast-MFC-AGG-ID: bnR8WeZsNUeiVOwHO6FDcw_1740074310
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4394040fea1so6697885e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 09:58:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740074310; x=1740679110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kcz4xAWFqeCC9QetFE4PD7D4V/UBq/8o84kFOzOUJF4=;
        b=gSXNOn8b93Llj5og8nWK/rdACZ91uwffeNtbwmuWBnZ8/bsyn5ESuYQ46FCdSM2mpi
         0S4/FFPJE0wECDnE1oxDvS7anqQ0sCXkU/9UfiDfukBP6jdrf8T1OsznKsYWZblL++BC
         Ner12rs7Du+moE2bY8whyYGo7zph4A74UFi2PqiPffGvNFSNb+tcwr2mnGMwqrLHUCZw
         6mbpiqXQctNXDG0TM4Bs3QzBGnk9WANkaZ3/Ora8jgQes0ilqJMdFSq1I8A1j67+hqL8
         Ye512zXD7ynQr72my/MQCPgqs8Sksmk0G4elVnhEXRqs3Abao3tXVVsyFW4QCwuYaReb
         yUFQ==
X-Gm-Message-State: AOJu0YyoKCO7MX7UgnCw4erR9kXa/Prlut29545WW4Rx7IttufaBAPXp
	SY4+Kq82EB6wa1RCfePktcR3JaS/96Q0MgIsFqwcGqCZ449LSpNeCKVjYRiFS5c71FKjVE96Y4n
	U+ONl+kaTjgBBNLKKbkATIHisbdwG2VHM6gxRaYCOZOappw+/ipzmA6XR
X-Gm-Gg: ASbGncsbI+8zqt5iZJX/WLO4E54OWHtzkmwreoXJAUSq06Vv8izc87M/aWhOmodS5wP
	ND4q2vsgBkj9lAmO9f3p/ck5wHO+Ggh4y7TadeJD51QOftUzFcQRexoqBfA/2o2Gk6dTgpceSBR
	TP8jZ43Hyhp6AFolNmwWamQIicj6PGZMuDlSey+N+O753vkyzGaRe5fETBh8YtK2T+4JBdWswU7
	4oA2V+wtxAMebQ8I3U0i8dJdIFA94DlPzfWsECrl4qavoyrSKGhTBcGopW8MbU8CRfd753dQlxj
	S41czmarDxQT5x9R1of7Mrlh
X-Received: by 2002:a05:600c:4f02:b0:439:4c1e:d810 with SMTP id 5b1f17b1804b1-439ae2ed58amr517335e9.9.1740074310230;
        Thu, 20 Feb 2025 09:58:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFevJ4t9lsyD5O+Xs6aw146/9p2YSNpc9qttmVizXYe7rZkVSNnTz99BRCzWmKdxc30XaRRuQ==
X-Received: by 2002:a05:600c:4f02:b0:439:4c1e:d810 with SMTP id 5b1f17b1804b1-439ae2ed58amr517215e9.9.1740074309737;
        Thu, 20 Feb 2025 09:58:29 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5b40sm21493751f8f.68.2025.02.20.09.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 09:58:29 -0800 (PST)
Date: Thu, 20 Feb 2025 18:58:28 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs-apply: allow stgit users to force-apply a patch
Message-ID: <m5r265vv4kjcvz7gtlywkryysm4pqlkudqmmy5ojiw5sgyf23x@syraduxt6geg>
References: <20250220164933.GP21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220164933.GP21808@frogsfrogsfrogs>

On 2025-02-20 08:49:33, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, libxfs-apply handles merge conflicts in the auto-backported
> patches in a somewhat unfriendly way -- either it applies completely
> cleanly, or the user has to ^Z, find the raw diff file in /tmp, apply it
> by hand, resume the process, and then tell it to skip the patch.
> 
> This is annoying, and I've long worked around that by using my handy
> stg-force-import script that imports the patch with --reject, undoes the
> partially-complete diff, uses patch(1) to import as much of the diff as
> possible, and then starts an editor so the caller can clean up the rest.
> 
> When patches are fuzzy, patch(1) is /much/ less strict about applying
> changes than stg-import.  Since Carlos sent in his own workaround for
> guilt, I figured I might as well port stg-force-import into libxfs-apply
> and contribute that.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> per maintainer request
> ---
>  tools/libxfs-apply |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 62 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 097a695f942bb8..9fb31f74d5c9af 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -297,6 +297,64 @@ fixup_header_format()
>  
>  }
>  
> +editor() {
> +	if [ -n "${EDITOR}" ]; then
> +		${EDITOR} "$@"
> +	elif [ -n "${VISUAL}" ]; then
> +		${VISUAL} "$@"
> +	elif command -v editor &>/dev/null; then
> +		editor "$@"
> +	elif command -v nano &>/dev/null; then
> +		nano "$@"
> +	else
> +		echo "No editor available, aborting messily."
> +		exit 1
> +	fi
> +}
> +
> +stg_force_import()
> +{
> +	local patch_name="$1"
> +	local patch="$2"
> +
> +	# Import patch to get the metadata even though the diff application
> +	# might fail due to stg import being very picky.  If the patch applies
> +	# cleanly, we're done.
> +	stg import --reject -n "${patch_name}" "${patch}" && return 0
> +
> +	local tmpfile="${patch}.stgit"
> +	rm -f "${tmpfile}"
> +
> +	# Erase whatever stgit managed to apply, then use patch(1)'s more
> +	# flexible heuristics.  Capture the output for later use.
> +	stg diff | patch -p1 -R
> +	patch -p1 < "${patch}" &> "${tmpfile}"
> +	cat "${tmpfile}"
> +
> +	# Attach any new files created by the patch
> +	grep 'create mode' "${patch}" | sed -e 's/^.* mode [0-7]* //g' | while read -r f; do
> +		git add "$f"
> +	done
> +
> +	# Remove any existing files deleted by the patch
> +	grep 'delete mode' "${patch}" | sed -e 's/^.* mode [0-7]* //g' | while read -r f; do
> +		git rm "$f"
> +	done
> +
> +	# Open an editor so the user can clean up the rejects.  Use readarray
> +	# instead of "<<<" because the latter picks up empty output as a single
> +	# line and does variable expansion...  stupid bash.
> +	readarray -t rej_files < <(grep 'saving rejects to' "${tmpfile}" | \
> +				   sed -e 's/^.*saving rejects to file //g')
> +	rm -f "${tmpfile}"
> +	if [ "${#rej_files[@]}" -gt 0 ]; then
> +		echo "Opening editor to deal with rejects.  Changes commit when you close the editor."
> +		editor "${rej_files[@]}"
> +	fi
> +
> +	stg refresh
> +}
> +
>  apply_patch()
>  {
>  	local _patch=$1
> @@ -385,11 +443,13 @@ apply_patch()
>  		stg import -n $_patch_name $_new_patch.2
>  		if [ $? -ne 0 ]; then
>  			echo "stgit push failed!"
> -			read -r -p "Skip or Fail [s|F]? " response
> -			if [ -z "$response" -o "$response" != "s" ]; then
> +			read -r -p "Skip, force Apply, or Fail [s|a|F]? " response
> +			if [ -z "$response" -o "$response" = "F" -o "$response" = "f" ]; then
>  				echo "Force push patch, fix and refresh."
>  				echo "Restart from commit $_current_commit"
>  				fail "Manual cleanup required!"
> +			elif [ "$response" = "a" -o "$response" = "A" ]; then
> +				stg_force_import "$_patch_name" "$_new_patch.2"
>  			else
>  				echo "Skipping. Manual series file cleanup needed!"
>  			fi
> 

Thanks! Works great, lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Sending fix for stgit detection in reply to this patch

-- 
- Andrey

