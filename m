Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D33126A0
	for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2026 08:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786522902; cv=none; b=TpbUai6ljMHHf7DTFUyBpFXhsM8Sg3J014UXxVg/Noh3clr2hd2D/VwraEOXjTXshHDXoEWkF49t38Igda9xCyzYLxK9SwptmVy36Udpgj18fUNs7WzMRyrxmawcr686Mdx1NJYFQlG/fulMlVZEIPVF25gnWULYaLnDCH0G1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786522902; c=relaxed/simple;
	bh=hy/MamDCMKEK8tredr9dX1Yq8W7ZbKsIAO08UW2RMxg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JsKHLaIws21CQHFpM94KVdmVrXmBDboPnup1crwhyuDnqHTj83Zl2khI97DTDR+hWIqzVPXwC+LuhzqjiMNzGsjDiGhl6oPxQIuP+wgsatPpWWPiTp5F0i3iUkHzGPCZrXMX5Gtj58lYNh55qwu/rqv54M8V8gqd233aksqQCms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rSFi5MpU; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rSFi5MpU"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15b1da6b82so71368866b.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2026 01:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786522899; x=1787127699; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=el1pI9AYgbxBMZGemIgcUaMPCb1Mfx6+kLcyrWecEeM=;
        b=rSFi5MpUYDS7aJrsmum3STIcKg1tFv5isLQtq5aMD0h0tPCHqdE9sNB+ptdCv5hQJQ
         jVjcpiLTBx7Ahr87NkOUX/0wE/lHVNGE6WAUcUTtr670VpD8n1LEGZM2qh1WN7Jexmpn
         Nndad0YHChscMXuU/3w5WiCTOjEDzx+EzwXKtQNWNn1HzbnQUlBMiimxBu5ij4r0Ge1m
         viq0Omdz9Ijy0MGfIIXrYnDk9DlDKeEe2HJWsY2w6joClIMUfgR5bzDZ6ls5uTB1jAhI
         NlP6ACSjh+hgr0CdauBFC+akmF8g1WUW9bL/z9IrYPn2KKswQPRqYdYSXRW3GaDzpgcV
         qgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522899; x=1787127699;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=el1pI9AYgbxBMZGemIgcUaMPCb1Mfx6+kLcyrWecEeM=;
        b=Ktc9qkljAkIa5p+skwN38JHB9VZvypXp+SnUWpMu+mVcWNPWIiJqjaPD9Mv/qv3Y6m
         AGLUJiqQW4dxjy2EWJC6krxP3Ps5WYxfWSpmID3JQJehK21hV8PRpdLHP7UDnrOTS/sZ
         QZI/+3ASkasw+vRwmCvtuGzymopL1OskwmJK3s0jW8V9l+Lvj7ZzEoizx3aB2ExYk1Eo
         LC8IxqUC7WXZOCU7lYkZSloGxR98M/Vya4QeHBKswN+98NrUmmxFq1BKXPPSTTDXIu/8
         75vR5nSM+vWSKggjqRc5aJrUfNAmsZty+lBbUw3f+rU8utEqWVCxI0NcppNCo0nWVeEC
         91dg==
X-Gm-Message-State: AOJu0YwAyyJSizTdPpUvMq04Q9CMDQdo63okGvopAzd7iRxuGNl/gt08
	czL9HMFyZbSbH5Ulib2CFpRd28b136dhUCzRvBMjdGDq14EiTGRt4Q09
X-Gm-Gg: AR+sD112pMhjvaq3vUV8VwFj/to4KSBct5tTFn2TkZ+2mLESV4WPXVH5WoBnpYRF2+5
	GXal92PQaOmkdP6FFBY39PuHbvNnnkIK8vMkRtpguX0NAOGck92pDicBdm4BUQoG3wxk8TnvQx2
	y9APLMILC/ieus0XUL5jGj1KZt1qwbk1DrCweJHT0lbzGr24rzVBwf2xZtqz0XLzHRkZJY+r455
	eBP526C596fv/f69WvssDg91oS8O7NdS/+r3k/o0eMhI4JzOCrSDEU/wSf4U2VMQEsLKjsQfGX9
	JNMNiTC3q5qDr0ztRJyCa0zAQOS130nF8VGyjcIZ2/Dz8NwAw4Qxzv/hb5emsW7keps/5YbTr8W
	x8vA/1eo2tfCac+7WAYdknH6JkhkuOrlgRaIddcqRRT4rQrnp6CqUTIc+LUVudrwxDr1lwHzwpC
	0L8jagpm6PiTBZ3+XJt5r4ZhW8sVHz9BO20Tzqvw26D6l6fXFsEh7NBAcz
X-Received: by 2002:a17:906:f596:b0:c20:3733:a8c5 with SMTP id a640c23a62f3a-c20f2eab500mr153277666b.8.1786522898986;
        Wed, 12 Aug 2026 01:21:38 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20f07a7a3esm62042066b.21.2026.08.12.01.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 01:21:38 -0700 (PDT)
Date: Wed, 12 Aug 2026 11:21:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: don't swallow dquot recovery verification errors
Message-ID: <anwtD6KQL_YA6yME@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Long Li,

Commit e2b4a856085e ("xfs: don't swallow dquot recovery verification
errors") from Jul 27, 2026 (linux-next), leads to the following
Smatch static checker warning:

	fs/xfs/xfs_dquot_item_recover.c:146 xlog_recover_dquot_commit_pass2()
	warn: missing error code here? 'xfs_dquot_verify()' failed. 'error' = '0'

fs/xfs/xfs_dquot_item_recover.c
    60 STATIC int
    61 xlog_recover_dquot_commit_pass2(
    62         struct xlog                        *log,
    63         struct list_head                *buffer_list,
    64         struct xlog_recover_item        *item,
    65         xfs_lsn_t                        current_lsn)
    66 {
    67         struct xfs_mount                *mp = log->l_mp;
    68         struct xfs_buf                        *bp;
    69         struct xfs_dqblk                *dqb;
    70         struct xfs_disk_dquot                *ddq, *recddq;
    71         struct xfs_dq_logformat                *dq_f;
    72         xfs_failaddr_t                        fa;
    73         int                                error;
    74         uint                                type;
    75 
    76         /*
    77          * Filesystems are required to send in quota flags at mount time.
    78          */
    79         if (mp->m_qflags == 0)
    80                 return 0;
    81 
    82         recddq = item->ri_buf[1].iov_base;
    83         if (recddq == NULL) {
    84                 xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
    85                 return -EFSCORRUPTED;
    86         }
    87         if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot)) {
    88                 xfs_alert(log->l_mp, "dquot too small (%zd) in %s.",
    89                         item->ri_buf[1].iov_len, __func__);
    90                 return -EFSCORRUPTED;
    91         }
    92 
    93         /*
    94          * This type of quotas was turned off, so ignore this record.
    95          */
    96         type = recddq->d_type & XFS_DQTYPE_REC_MASK;
    97         ASSERT(type);
    98         if (log->l_quotaoffs_flag & type)
    99                 return 0;
    100 
    101         /*
    102          * At this point we know that quota was _not_ turned off.
    103          * Since the mount flags are not indicating to us otherwise, this
    104          * must mean that quota is on, and the dquot needs to be replayed.
    105          * Remember that we may not have fully recovered the superblock yet,
    106          * so we can't do the usual trick of looking at the SB quota bits.
    107          *
    108          * The other possibility, of course, is that the quota subsystem was
    109          * removed since the last mount - ENOSYS.
    110          */
    111         dq_f = item->ri_buf[0].iov_base;
    112         ASSERT(dq_f);
    113         fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
    114         if (fa) {
    115                 xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
    116                                 dq_f->qlf_id, fa);
    117                 return -EFSCORRUPTED;
    118         }
    119         ASSERT(dq_f->qlf_len == 1);
    120 
    121         /*
    122          * At this point we are assuming that the dquots have been allocated
    123          * and hence the buffer has valid dquots stamped in it. It should,
    124          * therefore, pass verifier validation. If the dquot is bad, then the
    125          * we'll return an error here, so we don't need to specifically check
    126          * the dquot in the buffer after the verifier has run.
    127          */
    128         error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
    129                                    XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
    130                                    &xfs_dquot_buf_ops);
    131         if (error)
    132                 return error;
    133 
    134         ASSERT(bp);
    135         dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
    136         ddq = &dqb->dd_diskdq;
    137 
    138         /*
    139          * If the dquot has an LSN in it, recover the dquot only if it's less
    140          * than the lsn of the transaction we are replaying.
    141          */
    142         if (xfs_has_crc(mp)) {
    143                 xfs_lsn_t        lsn = be64_to_cpu(dqb->dd_lsn);
    144 
    145                 if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
--> 146                         goto out_release;

Originally this function always returned zero, but now it returns
error codes.  Should this be an error path?

    147                 }
    148         }
    149 
    150         memcpy(ddq, recddq, item->ri_buf[1].iov_len);
    151         if (xfs_has_crc(mp)) {
    152                 xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
    153                                  XFS_DQUOT_CRC_OFF);
    154         }
    155 
    156         /* Validate the recovered dquot. */
    157         fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
    158         if (fa) {
    159                 XFS_CORRUPTION_ERROR("Bad dquot after recovery",
    160                                 XFS_ERRLEVEL_LOW, mp, dqb,
    161                                 sizeof(struct xfs_dqblk));
    162                 xfs_alert(mp,
    163  "Metadata corruption detected at %pS, dquot 0x%x",
    164                                 fa, dq_f->qlf_id);
    165                 error = -EFSCORRUPTED;
    166                 goto out_release;
    167         }
    168 
    169         ASSERT(dq_f->qlf_size == 2);
    170         ASSERT(bp->b_mount == mp);
    171         xfs_buf_delwri_queue(bp, buffer_list);
    172 
    173 out_release:
    174         xfs_buf_relse(bp);
    175         return error;
    176 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
