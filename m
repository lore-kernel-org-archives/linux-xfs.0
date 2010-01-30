Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UJj3sm233197 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 13:45:04 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2C1B188678
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:46:10 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id Xu85GkOONBbmxKqZ for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:46:10 -0800 (PST)
Message-ID: <4B648C82.3040801@sandeen.net>
Date: Sat, 30 Jan 2010 13:46:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
References: <4B633F9A.8000404@sandeen.net>
	<20100130105501.GA22909@infradead.org>
	<4B645B0D.205@sandeen.net> <20100130172502.GA788@thunk.org>
	<4B647AFE.5000507@sandeen.net>
	<20100130191113.GC10181@infradead.org>
In-Reply-To: <20100130191113.GC10181@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, tytso@mit.edu, Giel de Nijs <giel@vectorwise.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sat, Jan 30, 2010 at 12:31:26PM -0600, Eric Sandeen wrote:
>> These are the deps that I know xfstests has, to build and to run:
>>
>> BuildRequires:  autoconf, libtool, xfsprogs-devel, e2fsprogs-devel
>> BuildRequires:  libacl-devel, libattr-devel, libaio-devel
>>
>> Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
>> Requires:       bc, indent, quota
>>
>> which isn't so bad...
> 
> Doesn't seem to bad.  Indent is afaik only needed for the weird 122 test
> which doesn't apply to non-xfs filesystems.

and FWIW, we do:

_require_command /usr/bin/indent

so it'll just not run if it's not there (the above was for an rpm
attempt I made, wishing to automatically pull in everything that
might possibly be needed.)

-Eric

>> I'm not sure an xfsprogs dependency is so onerous; plenty has depended
>> on e2fsprogs through the years and we've lived with that ;)  But
>> the lag time for xfsprogs to use released xfs_io functionality is a
>> bit of a bummer.
>>
>> But I guess I don't have a great answer for who else uses xfs_io:
> 
> I use xfs_io in lots various local scripts.  It's a really handly
> tool for exercising some of the more weird I/O related syscalls.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
