Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 22:06:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8I56ouw008673
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 22:06:53 -0700
Message-ID: <46EF5DA6.9090000@sgi.com>
Date: Tue, 18 Sep 2007 15:09:58 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] simplify validata_fields
References: <20070914162746.GB7110@lst.de> <46EF4C51.5060503@sgi.com> <20070918035616.GA12857@lst.de>
In-Reply-To: <20070918035616.GA12857@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Sep 18, 2007 at 01:56:01PM +1000, Lachlan McIlroy wrote:
>> Can we drop the i_size_read() check and just call i_size_write()?
>> The work we may not do by not calling i_size_write() we have to do
>> in i_size_read() anyway, sometimes doing the work twice.  And we
>> get to lose another stack variable.
> 
> Sounds good to me, but I'd prefer to keep it in a separate patch
> so this is just the mechanical removal of the xfs_getattr call.
> 
> I'll send a separate patch for it today or tomorrow.

Okay, thanks.
