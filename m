Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 17:43:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l550hTWt016204
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 17:43:30 -0700
Date: Tue, 05 Jun 2007 10:47:24 +1000
Subject: Re: [PATCH 1/3] XFS metadump utility
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.ts0ukea43jf8g2@pc-bnaujok.melbourne.sgi.com> <20070604145258.GB28033@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ttfa5az43jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20070604145258.GB28033@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, 05 Jun 2007 00:52:58 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, May 28, 2007 at 03:22:52PM +1000, Barry Naujok wrote:
>> Back in February, I posted a patch to xfs_db to capture metadata from a
>> filesystem into a file
>> http://oss.sgi.com/archives/xfs/2007-02/msg00072.html .
>>
>> I have now updated it with the following changes:
>>  - obfuscates directory names and attribute names
>>  - zeros attribute values
>>  - better support of stdin/stdout for redirection.
>
> Is this the dpprintf to fprintf changes?  These changes look like they
> really want to be in a separate patch with at least a sentence of an
> explanation.

Nah, the fprintf instead of dbprintf was required so errors don't go to
stdout when using stdout as a target.

The better support is using fread/fwrite instead of read/write to a
handle.

> The newly added files look good to me from a quick glance.
>
