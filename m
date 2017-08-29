Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35335 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdH2Vf2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 17:35:28 -0400
Received: by mail-oi0-f54.google.com with SMTP id k77so37864516oib.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:35:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g@mail.gmail.com>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170829212606.GC8608@lst.de> <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 14:35:27 -0700
Message-ID: <CAPcyv4i2rS0sAxiJSVxFSHirsycaYofuxp3yPxeyB8xzsryx3g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Aug 29, 2017 at 2:31 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Aug 29, 2017 at 2:26 PM, Christoph Hellwig <hch@lst.de> wrote:
>> Call me nitpicky, but..
>>
>> First this really should be three patches, one for the DAX code, one
>> for the VFS code and one for XFS.  The DAX and XFS bits looks fine to
>> me:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> But I'm a little worried about stuffing more DAX knowledge into the
>> block mount_bdev helper.  For now it's probably ok as everything
>> else would involve a lot of refactoring and/or duplication, but
>> I'm generally not too happy about it.
>
> I think this is why we ended up with calling dax_get_by_host() in
> ->iomap_begin() because the mount_bdev() touches I started with back
> when this was first introduced were not very palatable. I agree with
> the direction to move to mount_dax() in the future. I can respin this
> into three patches and a TODO comment about how we want to kill the
> dax knowledge in mount_bdev() going forward.

Actually, why not just do this directly in xfs_fs_mount()? I think I
can refactor this to not touch mount_bdev() and put all the details in
the per-fs mount/umount paths.
