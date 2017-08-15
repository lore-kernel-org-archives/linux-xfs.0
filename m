Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34154 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbdHOQ3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 12:29:31 -0400
Received: by mail-yw0-f170.google.com with SMTP id s143so7759139ywg.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 09:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170815124250.GG27505@quack2.suse.cz>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815124250.GG27505@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Aug 2017 09:29:30 -0700
Message-ID: <CAPcyv4h01os0Gc6bYmaGdMXt5q4G4zfirNRPWG3=gQi5POrpmg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Tue, Aug 15, 2017 at 5:42 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 14-08-17 23:12:22, Dan Williams wrote:
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index ff151814a02d..73fdc0ada9ee 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -306,6 +306,7 @@ struct vm_area_struct {
>>       struct mm_struct *vm_mm;        /* The address space we belong to. */
>>       pgprot_t vm_page_prot;          /* Access permissions of this VMA. */
>>       unsigned long vm_flags;         /* Flags, see mm.h. */
>> +     unsigned long fs_flags;         /* fs flags, see MAP_DIRECT etc */
>>
>>       /*
>>        * For areas with an address space and backing store,
>
> Ah, OK, here are VMA flags I was missing in the previous patch :) But why
> did you create separate fs_flags field for this? on 64-bit archs there's
> still space in vm_flags and frankly I don't see why we should separate
> MAP_DIRECT or MAP_SYNC from other flags?

Where would MAP_DIRECT go in the 32-bit case?

> After all a difference in these
> flags must also prevent VMA merging (which you forgot to handle I think)
> and they need to be copied on split (which happens by chance even now).

Ah, yes I did miss blocking the merge of a vma with MAP_DIRECT and one
without. However, the vma split path looks ok.
