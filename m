Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 19:07:04 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B26iT1024968
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 19:06:45 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: Lost+found
References: <1207632033.11530.10.camel@localhost.localdomain>
	<op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com>
	<alpine.DEB.1.10.0804090628080.322@p34.internal.lan>
	<47FCC071.40201@sandeen.net> <20080409132945.GA25114@infradead.org>
Date: Fri, 11 Apr 2008 12:07:07 +1000
In-Reply-To: <20080409132945.GA25114@infradead.org> (Christoph Hellwig's
	message of "Wed, 9 Apr 2008 09:29:45 -0400")
Message-ID: <nccy77lf8l0.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, Barry Naujok <bnaujok@sgi.com>, Jeffrey Sandel <webmaster@javainbaja.com>, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:
> On Wed, Apr 09, 2008 at 08:11:13AM -0500, Eric Sandeen wrote:
>> The whole reason they're in lost+found is because they are "orphaned" -
>> allocated & in use but not referenced by any directory... so the best
>> xfs_repair can do is rename to lost+found with the inode number.
>
> At least until we get parent pointers.  Niv, any updates?

I was lost in DMAPI land for a while, I'll resume work on PP next week,
patches up for review soonish after I fix some issues.

Cheers,
-- 
Niv Sardi
