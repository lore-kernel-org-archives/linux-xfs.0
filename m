Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 17:06:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3I06PdE008894
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 17:06:27 -0700
Subject: Re: [REVIEW] - cleanup xfs_attr a bit
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t9qhhmhx3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080417182702.GA7154@infradead.org>
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Apr 2008 10:10:22 +1000
Message-ID: <op.t9r5fkh53jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080417182702.GA7154@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, 18 Apr 2008 04:27:02 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Thu, Apr 17, 2008 at 12:35:36PM +1000, Barry Naujok wrote:
>> This patch starts using struct xfs_name more for the xattr code and
>> is another step for using xfs_name in xfs_da_args.
>>
>> Also, the cred parameter is removed from xfs_attr_get and  
>> xfs_attr_fetch.
>
> Looks good, but I'd really not expected a function called
> xfs_attr_name_to_name to do the shutdown check.  Either keep it in the
> callers or give the function a different name.

I agree with that sentiment, just couldn't think of a better name :)
