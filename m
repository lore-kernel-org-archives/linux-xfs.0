Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36852 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754972AbdEKIbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 04:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <20170511075926.GC19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de> <20170510180214.16852-4-hch@lst.de>
 <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com> <20170511075926.GC19837@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 May 2017 11:31:40 +0300
Message-ID: <CAOQ4uxg0xRNw_pVipXqt_qpNm58uzp+VLYTcwMVypmmZZ-ztcg@mail.gmail.com>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, May 11, 2017 at 10:59 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, May 10, 2017 at 10:15:51PM +0300, Amir Goldstein wrote:
>> > +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
>> >  {
>> > -       return memcmp(&u1, &u2, sizeof(uuid_be));
>> > +       return memcmp(&u1, &u2, sizeof(uuid_t));
>> >  }
>> >
>>
>>
>> I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
>> which is more in line with the rest of the helpers including the new helpers
>> hoisted from xfs.
>
> Or just kill them off - uuid/guid_equals is the better interface for all
> existing users as far as I can tell.  My updated series already kills
> off the be/uuid one, the le/guid one will need a bit more work, though.

That works too. and for another argument, why need a helper uuid/guid_cmp
when one can use C comparison (i.e. u1 != u2) ? assuming that we have no
reason to abstract that fact that uuid_t/guid_t are a struct type.
