Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286521B0F0A;
	Sun, 22 Jun 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750595552; cv=none; b=jLhZG61uWg7B2Hlc4gjzrLCyUAZylmwIwYxb1XF8MY+c90QDz7CTHno2U/KIo+ZFJovlbqVD05dlhdzNUNeAbLJ8auUTHTQcC9cS+13pe6TNgNiqpxY2b/Ujz9vYIBOzwqCCJemh3ekecDzNd/41yYjNOlwpjoS4PCnFkW3lRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750595552; c=relaxed/simple;
	bh=jXXXkw+FKbQmB/tcR68RCa7x6xWvdO657V53b7GpzSk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=sF2HbGMeXUqVcaaZqFlTfgT5wApS2Sq58xdjpdP5fO6Qu5KrIgVxXzvQt7sSndMKPVXWNppgWmsRtC1VpV1uBNOMwCyESwbXB2PFPjFnVU9FIWSaGKomfNNxNEDHxX9WCV91R1gvgTdWT8rjOTa5j5UMLEQfYTwlIFWUMytyVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eKGmoZbv; arc=none smtp.client-ip=209.85.218.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eKGmoZbv"
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-ad89c32a7b5so540328366b.2;
        Sun, 22 Jun 2025 05:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750595549; x=1751200349; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aSk4yzTW44Esyzw/wNejCuPulTn02jN2YGNDUPCIWYk=;
        b=eKGmoZbvhwY7IBKBNGRvN4rVH83ARcQnd5fhix/QHX0+2eBiDulLFTbc4xiyW22sEx
         FrtHrfwK4qBHKS4uw+sGzHiIzoPKVDa1OGpUBvyHaE4GYoC0MPf6x7noA8Z2ylTVwL0j
         ZH2aodIzsbLTNGCXrefaRbBeVvO/ahLJ/QRgD045jrHCHkBNJ5R/9ZPfSBs5v5kVp/ZD
         Cwu1tCXYes1YRenlusgjWLdwQcTtYq6+/x45eFOHknZemiEuVk/zZ+s+XPJ6JCid/NsA
         w+LFZHxX4uIjGWSj2EkURMITJBBafxs2f4plxsCeq9jWxA4ajHZvygWXbu82ptDNvJ+P
         rozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750595549; x=1751200349;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aSk4yzTW44Esyzw/wNejCuPulTn02jN2YGNDUPCIWYk=;
        b=VNA8mQ6bBP+WKYx/CekgMnte9vaYfzA1vE7f99Hgx6JHNGdtXjKurXtBTeXl5M2Az6
         fzUPJDg2czwo4jP2MdV6HpxzHS/Glg8dX3ND/RaLIl1CSdSFAWDhR2KXuak6VCp1yttm
         btEri+0ilDfLkDHQhhJ3lSADTXQnWpIwQCTSmxG7jbAmHwpYmS1CRP6D+BOtLkO9iHsH
         Qa8WZVEmdBcQLynCRuk50oVBUCbNEUWyjQRQgtVhhuL5ScVNRzpuHaNkZuDtsUzQ23wY
         Pp3M+nx19zkk11fW/jZgBSlq8+ng+j7R1H0L2uimsX8IZMFgU/WFRYLYC/+3x4WnZu3y
         Bh/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWdjcYEVzGKEExI/AED1JSG7aac2NUa20dT+y64/AC/JkvSVl1UIAJZkSt0nP2pFiuKQ5nKaOIRu5GqBrA=@vger.kernel.org, AJvYcCWzcf66/30uMfzapYQA2Af1JlxeYjTn5GVoUfGcgtMh6nSTHDYPB/AL0MQMWlDmYtu6be8D542MGbxe@vger.kernel.org
X-Gm-Message-State: AOJu0Yw86LmjqfecZWO75pbyyrXmFdUpAiNbBct+kczarlSUu+AJ+ekw
	QX9ZrrE7EfyzelBKwBrKYHwdNPv5Bfa0TgJJu+W3I01EewVn+J8qhziJW8xftfFk9LBnebIwpho
	F4AClQMeqWZo1/xgpr9ZocxER8wmmtxDY9d5xZ1I=
X-Gm-Gg: ASbGncuwVL2+enFcmmVPyYIIPqgerD8DwrArnb6sR0XzWvvVi3Rte/Rom+9G9Wr1Lu7
	/cWlZLP4lEANBahFXAtpeQ+TsIhElwLOvNjx8HcoRkzCcTK8shupYG0IYjWSuloK0or3BF7nI12
	872llKIHa8Q15ovTUW+HGdSVvnay0ixLipRNVhM70FYSmI
X-Google-Smtp-Source: AGHT+IE9OBYcaOHJZRl28LCepjQAPhnCJC5wHlYtncAitDnkEJr39Z3wrHc73rGhhccLPxyswT4nlwcy7/sGTOTntBM=
X-Received: by 2002:a17:907:d2d2:b0:ad8:8d89:bbec with SMTP id
 a640c23a62f3a-ae057b89b81mr873810066b.28.1750595549263; Sun, 22 Jun 2025
 05:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ying chen <yc1082463@gmail.com>
Date: Sun, 22 Jun 2025 20:32:18 +0800
X-Gm-Features: AX0GCFskuPouvmaUOWn_8Wqpj2uL6bAVD6Tu66NzJt9rqUcrykyiU8gyOEZOEEw
Message-ID: <CAN2Y7hyi1HCrSiKsDT+KD8hBjQmsqzNp71Q9Z_RmBG0LLaZxCA@mail.gmail.com>
Subject: [PATCH] xfs: report a writeback error on a read() call
To: djwong@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Normally, user space returns immediately after writing data to the
buffer cache. However, if an error occurs during the actual disk
write operation, data loss may ensue, and there is no way to report
this error back to user space immediately. Current kernels may report
writeback errors when fsync() is called, but frequent invocations of
fsync() can degrade performance. Therefore, a new sysctl
fs.xfs.report_writeback_error_on_read is introduced, which, when set
to 1, reports writeback errors when read() is called. This allows user
space to be notified of writeback errors more promptly.

Signed-off-by: fengchangqing <fengchangqing@pinduoduo.com>
---
 fs/xfs/xfs_file.c    | 9 +++++++++
 fs/xfs/xfs_globals.c | 1 +
 fs/xfs/xfs_linux.h   | 1 +
 fs/xfs/xfs_sysctl.c  | 9 +++++++++
 fs/xfs/xfs_sysctl.h  | 1 +
 5 files changed, 21 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 595a5bc..8bf0a83 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -288,12 +288,21 @@
        struct inode            *inode = file_inode(iocb->ki_filp);
        struct xfs_mount        *mp = XFS_I(inode)->i_mount;
        ssize_t                 ret = 0;
+       int                     error = 0;
+       errseq_t                since;

        XFS_STATS_INC(mp, xs_read_calls);

        if (xfs_is_shutdown(mp))
                return -EIO;

+       if (xfs_report_writeback_error_on_read) {
+               since = READ_ONCE(iocb->ki_filp->f_wb_err);
+               error = filemap_check_wb_err(inode->i_mapping, since);
+               if (error)
+                       return  error;
+       }
+
        if (IS_DAX(inode))
                ret = xfs_file_dax_read(iocb, to);
        else if (iocb->ki_flags & IOCB_DIRECT)
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4d0a98f..9983a2f 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -29,6 +29,7 @@
        .inherit_nodfrg = {     0,              1,              1       },
        .fstrm_timer    = {     1,              30*100,         3600*100},
        .blockgc_timer  = {     1,              300,            3600*24},
+       .report_writeback_error_on_read = {     0,              0,
         1},
 };

 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f987802..bbe8bdb 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -100,6 +100,7 @@
 #define xfs_inherit_nodefrag   xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs    xfs_params.fstrm_timer.val
 #define xfs_blockgc_secs       xfs_params.blockgc_timer.val
+#define xfs_report_writeback_error_on_read
xfs_params.report_writeback_error_on_read.val

 #define current_cpu()          (raw_smp_processor_id())
 #define current_set_flags_nested(sp, f)                \
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 546a6cd..fbec214 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -194,6 +194,15 @@
                .extra1         = &xfs_params.blockgc_timer.min,
                .extra2         = &xfs_params.blockgc_timer.max,
        },
+       {
+               .procname       = "report_writeback_error_on_read",
+               .data           =
&xfs_params.report_writeback_error_on_read.val,
+               .maxlen         = sizeof(int),
+               .mode           = 0644,
+               .proc_handler   = xfs_deprecated_dointvec_minmax,
+               .extra1         =
&xfs_params.report_writeback_error_on_read.min,
+               .extra2         =
&xfs_params.report_writeback_error_on_read.max,
+       },
        /* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
        {
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index f78ad6b..fa0688a 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -36,6 +36,7 @@
        xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
        xfs_sysctl_val_t fstrm_timer;   /* Filestream dir-AG assoc'n timeout. */
        xfs_sysctl_val_t blockgc_timer; /* Interval between blockgc scans */
+       xfs_sysctl_val_t report_writeback_error_on_read; /*  Report a
writeback error on a read() call. */
 } xfs_param_t;

 /*
--
1.8.3.1
