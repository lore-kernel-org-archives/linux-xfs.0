Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14EBA7F50
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 12:56:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D98E28F8035
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id W17C6nybZ2lAJYoC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 10:56:46 -0800 (PST)
Date: Wed, 13 Nov 2013 10:56:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131113185645.GA20869@infradead.org>
References: <5283C41D.7070503@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5283C41D.7070503@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 13, 2013 at 12:25:33PM -0600, Eric Sandeen wrote:
> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
> 
> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
> drive.  (that change was done by me).  The thought was that it'd be an
> efficiency gain to not make the drive do the (possible) RMW cycles on
> 512-byte log IO, primarily.
> 
> However, now this restricts all DIO to 4k alignment, not the otherwise-
> possible 512.
> 
> This came up when qemu-kvm, in cache=none mode, tries to boot off an
> image hosted on such a filesystem, and its bios wants to do a 512 byte
> direct IO read off the disk - it fails.
> 
> But I'm wondering - the buftarg's bt_sshift and bt_smask are only used
> in a few places.  

No need to mess with kernel code IFF we want to change that, just keep
the sector size at 512 bytes and set a log stripe unit at mkfs time.

I have to admit that I'm not really sure if that's what we really want,
through.  A drive that has a larger physical block size will need
read-modify-write cycles internally, which we try to avoid.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
