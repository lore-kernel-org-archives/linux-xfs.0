Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34624 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbeCMGss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 02:48:48 -0400
Received: by mail-yw0-f193.google.com with SMTP id x17so3107089ywj.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Mar 2018 23:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com>
References: <1516952669-14769-1-git-send-email-amir73il@gmail.com>
 <20180126214404.GE9068@magnolia> <CAOQ4uxgVaGgwio=538-PP4QuRbcny6q0_CAeV-9bQEWBaxv2gA@mail.gmail.com>
 <20180129155054.GJ9359@magnolia> <CAOQ4uxjMfZGMtbq2vRN8dL5QvgC0=UD-yWDbNib=dckDTFR0Nw@mail.gmail.com>
 <20180201003511.GK4849@magnolia> <CAOQ4uxjE31j7XDpEGnnym7cgD_kqsPnio4KN2gphajsCNMrG1g@mail.gmail.com>
 <20180311162442.GB2013@kroah.com> <20180312162744.GB4865@magnolia> <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 13 Mar 2018 08:48:47 +0200
Message-ID: <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 12, 2018 at 10:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Mar 12, 2018 at 6:27 PM, Darrick J. Wong
[...]

>>> > > I meant the other things that went into 4.16, like the reflink quota
>>> > > fixes, the directio corruption problems, etc.  Make a branch, add the
>>> > > necessary fixes, run xfstests to make sure it all still works, etc.
>>                        ^^^^^^^^^^^^
>> Hi Amir, could you do   this step   ?
>>
>
> Will do.
>

Quick question.

I don't run -g auto regularly and now when running -g auto on
v4.15.9 I get a bunch of soft lockups on:

[37036.050685]  xfs_bmapi_write+0x61a/0xed1
[37036.051794]  xfs_reflink_convert_cow+0x9d/0xbf
[37036.052761]  ? xfs_vm_writepages+0x42/0x99
[37036.053617]  xfs_submit_ioend+0x3b/0xf8
[37036.054459]  xfs_vm_writepages+0x79/0x99

Can anyone share a good expunge list for running latest xfs/xfstest/xfsprogs
with -g auto and reflink support?

Thanks,
Amir.
