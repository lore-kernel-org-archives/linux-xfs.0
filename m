Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n678x6wU134291 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 03:59:07 -0500
Subject: Re: [PATCH, RFC] default to inode64 on 64-bit systems
References: <4A52419E.5020301@sandeen.net>
	<20090706184257.GA18107@infradead.org>
From: Olaf Weber <olaf@sgi.com>
Date: Tue, 07 Jul 2009 10:59:37 +0200
In-Reply-To: <20090706184257.GA18107@infradead.org> (Christoph Hellwig's
	message of "Mon, 6 Jul 2009 14:42:57 -0400")
Message-ID: <bzyhbxoc1hi.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig writes:
> On Mon, Jul 06, 2009 at 01:25:34PM -0500, Eric Sandeen wrote:

>> I'm tiring of telling people to use the inode64 mount option
>> when they are experiencing bad performance on large xfs 
>> filesystems...
>> 
>> 32-bit userspace is still largely broken when it comes to still
>> using 32-bit stat calls, but on 64-bit systems this should be
>> safe.
>> 
>> The only problem here is moving the disk onto a 32-bit system, or using
>> 32-bit apps.  But I think it's a small risk.
>> 
>> What do we think about the following?

> Looks good to me, but it could use a comment in the code explaining why
> we do this.

Making inode64 the default on 64 bit systems seems like a good idea to
me.  But would it not be advisable to have a mount option that forces
the old behaviour, just in case?  Something like "broken32bituserspace"
(or maybe "inode32").

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
