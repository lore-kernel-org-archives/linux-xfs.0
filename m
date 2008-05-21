Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 18:22:41 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L1MbFi031124
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 18:22:38 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A67C51B2F1AD
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 18:23:26 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id ShMNxFRxAaBqlDYl for <xfs@oss.sgi.com>; Tue, 20 May 2008 18:23:26 -0700 (PDT)
Message-Id: <1AE3C150C90A4C1A8C024C3D6079C948@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080514170625t-sato@mail.jp.nec.com> <20080520035712.GA7252@webber.adilger.int>
In-Reply-To: <20080520035712.GA7252@webber.adilger.int>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Wed, 21 May 2008 10:23:23 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@sun.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

Andreas Dilger wrote:
>> +static int ioctl_freeze(struct file *filp)
>> +{
>> +    struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +
>> +    if (!capable(CAP_SYS_ADMIN))
>> +        return -EPERM;
>> +
>> +    /* If filesystem doesn't support freeze feature, return. */
>> +    if (sb->s_op->write_super_lockfs == NULL)
>> +        return -EINVAL;
> 
> Should this be EINVAL, or EOPNOTSUPP?  Usually EINVAL means there is
> something wrong with the passed ioctl parameters (e.g. bad value),
> while EOPNOTSUPP is "operation not supported" and makes more sense.

Sounds good.
I will send new patch-set which is rebased to 2.6.26-rc3 and includes
this fix, in this weekend.

Cheers, Takashi
