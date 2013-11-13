Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 246307F53
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:08:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF26C304059
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 11:08:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3e3rSVls6tAznYsb for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 11:08:32 -0800 (PST)
Message-ID: <5283CE2E.2070702@sandeen.net>
Date: Wed, 13 Nov 2013 13:08:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
In-Reply-To: <20131113185645.GA20869@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/13/13, 12:56 PM, Christoph Hellwig wrote:
> On Wed, Nov 13, 2013 at 12:25:33PM -0600, Eric Sandeen wrote:
>> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
>>
>> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
>> drive.  (that change was done by me).  The thought was that it'd be an
>> efficiency gain to not make the drive do the (possible) RMW cycles on
>> 512-byte log IO, primarily.
>>
>> However, now this restricts all DIO to 4k alignment, not the otherwise-
>> possible 512.
>>
>> This came up when qemu-kvm, in cache=none mode, tries to boot off an
>> image hosted on such a filesystem, and its bios wants to do a 512 byte
>> direct IO read off the disk - it fails.
>>
>> But I'm wondering - the buftarg's bt_sshift and bt_smask are only used
>> in a few places.  
> 
> No need to mess with kernel code IFF we want to change that, just keep
> the sector size at 512 bytes and set a log stripe unit at mkfs time.
> 
> I have to admit that I'm not really sure if that's what we really want,
> through.  A drive that has a larger physical block size will need
> read-modify-write cycles internally, which we try to avoid.

Yeah, the problem comes up when it is 100% impossible to boot a
qemu-kvm guest hosted on such a filesystem/drive.  :(

(of course I guess that means it fails on a hard 4k drive too)

I don't know what the guest sees for logical/physical on its
file-backed block device in these cases.

Anyway, if we took your suggestion, normal internal fs operations
(log IO) wouldn't RMW.  But we'd still presumably advertise and allow
smaller DIO sizes, which are inefficient.  We could advertise 4k, but
still allow 512 for less-smart apps, maybe?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
