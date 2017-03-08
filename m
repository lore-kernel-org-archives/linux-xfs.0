Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35507 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdCHUOW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 15:14:22 -0500
Received: by mail-it0-f45.google.com with SMTP id m27so54403917iti.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2017 12:13:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170308155059.GA4353@infradead.org>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
 <1488963219-11709-4-git-send-email-elena.reshetova@intel.com> <20170308155059.GA4353@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Mar 2017 12:06:49 -0800
Message-ID: <CAGXu5jK3x+cPe4pccv0Q5W+9eDxu7n3Enih-TVRkysmwDwzGCA@mail.gmail.com>
Subject: Re: [PATCH 3/5] fs, xfs: convert xlog_ticket.t_ref from atomic_t to refcount_t
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, darrick.wong@oracle.com, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

On Wed, Mar 8, 2017 at 7:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> -     ASSERT(atomic_read(&ticket->t_ref) > 0);
>> -     atomic_inc(&ticket->t_ref);
>> +     ASSERT(refcount_read(&ticket->t_ref) > 0);
>> +     refcount_inc(&ticket->t_ref);
>
> With strict refcount semantics refcount_inc should check that
> the count is larger than 0, otherwise we'd need to use
> recount_inc_not_zero or whatever you're going to call it.
>
> Is that something the recount code does / could do?

Yes, refcount_inc() will not increment from 0 and WARNs. It looks like
xfs's ASSERT is also a warn (though with XFS-specific formatting), so
perhaps the ASSERT could be dropped? IIUC, Elena's approach to these
changes was to be conservative about removing the existing checks.

-Kees

-- 
Kees Cook
Pixel Security
