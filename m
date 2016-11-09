Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbcKIDoN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 22:44:13 -0500
Date: Wed, 9 Nov 2016 11:44:11 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 7/9] populate: discover XFS structure fields and fuzz
 verbs, and use them to fuzz fields
Message-ID: <20161109034411.GQ27776@eguan.usersys.redhat.com>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
 <147830507411.1919.17534443838350465519.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830507411.1919.17534443838350465519.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

[sorry, more comments on this patch]

On Fri, Nov 04, 2016 at 05:17:54PM -0700, Darrick J. Wong wrote:
> Create some routines to help us perform targeted fuzzing of individual
> fields in various XFS structures.  Specifically, we want the caller to
> drop the xfs_db iocursor on the victim field; from there, the scripts
> should discover all available fields and fuzzing verbs, and try each
> fuzz verb on every available field.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/fuzzy |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 191 insertions(+)
> 
> 
[snip]
> +
> +# Make sure we have all the pieces we need for field fuzzing
> +_require_scratch_xfs_fuzz_fields()
> +{
> +	_require_scratch
> +	_require_scrub
> +	_require_populate_commands
> +	_require_command "$XFS_DB_PROG" "xfs_db"

This is included in _require_populate_commands, not needed here.

> +	_scratch_mkfs_xfs >/dev/null 2>&1
> +	_scratch_xfs_db -x -c 'fuzz' 2>&1 | grep -q 'not found' && \
> +		_notrun "xfs_db does not have fuzz command"

Does _require_xfs_db_command work here?

Thanks,
Eryu

> +}
> +
> +# Grab the list of available fuzzing verbs
> +_scratch_xfs_list_fuzz_verbs() {
> +	if [ -n "${SCRATCH_XFS_LIST_FUZZ_VERBS}" ]; then
> +		echo "${SCRATCH_XFS_LIST_FUZZ_VERBS}" | sed -e 's/ /\n/g'
> +		return;
> +	fi
> +	_scratch_xfs_db -x -c 'sb 0' -c 'fuzz' | grep '^Verbs:' | \
> +		sed -e 's/[,.]//g' -e 's/Verbs: //g' -e 's/ /\n/g'
> +}
> +
> +# Fuzz the fields of some piece of metadata
> +_scratch_xfs_fuzz_fields() {
> +	_scratch_xfs_list_metadata_fields "$@" | while read field; do
> +		_scratch_xfs_list_fuzz_verbs | while read fuzzverb; do
> +			__scratch_xfs_fuzz_mdrestore
> +			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "$@"
> +		done
> +	done
> +}
> 
