Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 17:00:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3400Dk7027581
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 17:00:17 -0700
Message-ID: <47F56F9E.4080200@sgi.com>
Date: Fri, 04 Apr 2008 11:00:30 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403172400.GC22812@samba1> <47F51DDE.8070501@sandeen.net>
In-Reply-To: <47F51DDE.8070501@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org



Eric Sandeen wrote:
> Jeremy Allison wrote:
>> On Thu, Apr 03, 2008 at 01:14:50PM -0400, Christoph Hellwig wrote:
>>> Validating file names is not the filesystem job.  In fact it's utterly
>>> stupid, a unix filename is a sequence of bytes without special meaning
>>> except for ., .., / and \0
>> This patch will be extremely useful for users who are serving
>> Windows clients using Samba. It allow admins to turn off the
>> userspace case insensitivity we have to emulate and be a significant
>> speed increase.
> 
> I'd like to see the numbers... Simo tested an earlier version of this
> patch, and it was not faster.... 

Yes I'd like to see some numbers too. Simo, can you post details of your
testing (framework, methodology, results, etc).

>
> Jeremy, what would be a representative test setup to use?

Cheers
-- Mark

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
