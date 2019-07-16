Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53804 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733037AbfGPLGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jul 2019 07:06:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so18219026wmj.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 04:06:05 -0700 (PDT)
Date: Tue, 16 Jul 2019 13:06:02 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: test statfs on project quota directory
Message-ID: <20190716110602.pw5g33ynux5p5xpy@pegasus.maiolino.io>
References: <20190716093550.23059-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716093550.23059-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Zoro.

On Tue, Jul 16, 2019 at 05:35:50PM +0800, Zorro Lang wrote:
> There's a bug on xfs cause statfs get negative f_ffree value from
> a project quota directory. It's fixed by "de7243057 fs/xfs: fix
> f_ffree value for statfs when project quota is set". So add statfs
> testing on project quota block and inode count limit.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> This V2 patch changes this case from a generic case to a xfs only case, due to
> ext4 has different behavior.
> 
.
.
.
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_quota
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_enable_pquota
> +_qmount_option "prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +# Create a directory to be project object, and create a file to take 64k space
> +mkdir $SCRATCH_MNT/t
> +$XFS_IO_PROG -f -c "pwrite 0 65536" -c sync $SCRATCH_MNT/t/file >>$seqres.full
> +
> +# Setup temporary replacements for /etc/projects and /etc/projid
> +cat >$tmp.projects <<EOF
> +42:$SCRATCH_MNT/t
> +EOF
> +
> +cat >$tmp.projid <<EOF
> +answer:42
> +EOF

> +
> +quota_cmd="$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid"
> +$quota_cmd -x -c 'project -s answer' $SCRATCH_MNT >/dev/null 2>&1
> +$quota_cmd -x -c 'limit -p isoft=53 bsoft=100m answer' $SCRATCH_MNT

I wonder if is there any specific reason why you're using project quota config
files for this test? Maybe it would simplify the test if you replace the config
files and the quota command by something like:

$quota_cmd -x -c 'answer -s -p $SCRATCH_MNT/t 42' $SCRATCH_MNT >/dev/null 2>&1
$quota_cmd -x -c 'limit -p isoft=53 bsoft=100m 42' $SCRATCH_MNT

Which would remove from the test all the configuration files setup


> +
> +# The itotal and size should be 53 and 102400(k), as above project quota limit.
> +# The isued and used should be 2 and 64(k), as this case takes. But ext4 always
> +# shows more 4k 'used' space than XFS, it prints 68k at here. So filter the
> +# 6[48] at the end.

If this is a XFS only test, we don't need this comment right?

> +df -k --output=file,itotal,iused,size,used $SCRATCH_MNT/t | \
> +	_filter_scratch | _filter_spaces
> +

Cheers

-- 
Carlos
