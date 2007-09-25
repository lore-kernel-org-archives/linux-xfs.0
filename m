Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 18:31:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8P1VfQ3020704
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 18:31:46 -0700
Message-ID: <46F86501.7070605@sandeen.net>
Date: Mon, 24 Sep 2007 20:31:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] lose xfs_hex_dump in favor of print_hex_dump
References: <46F85240.1060206@sandeen.net> <20070925003232.GA26663@puku.stupidest.org>
In-Reply-To: <20070925003232.GA26663@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Chris Wedgwood wrote:

> On Mon, Sep 24, 2007 at 07:11:44PM -0500, Eric Sandeen wrote:
> 
>> +extern void xfs_hex_dump(void *p, int length);
>> +
> 
>> +void
>> +xfs_hex_dump(void *p, int length)
>> +{
>> +	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
>> +}
> 
> Is this symbol exported/needed?  If not then why not make it a #define
> or an inline in the header where you have the prototype?

Yeah, I suppose that might be better....  I just followed the lead of
xfs_cmn_err etc.

The only reason I left a wrapper was for cattelan's BSD exploits 
(er, adventures)  ;-)  I could imagine it getting called from other places, 
but for now it only has one caller, xfs_corruption_error (so really, even 
the length argument is never anything other than 16...)


-Eric
