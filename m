Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4169A7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 11:42:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A008CAC008
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 09:42:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XVjNpOWU1WJFTqm4 for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 09:42:18 -0700 (PDT)
Message-ID: <53EA43E6.5010100@sandeen.net>
Date: Tue, 12 Aug 2014 09:42:14 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Location of backup superblocks
References: <CACyNnZNfTxxy0PsGKHgthoiGc74O_28uumGeG0CjLprxtiDv-Q@mail.gmail.com>
In-Reply-To: <CACyNnZNfTxxy0PsGKHgthoiGc74O_28uumGeG0CjLprxtiDv-Q@mail.gmail.com>
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
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>, xfs@oss.sgi.com

On 8/12/14, 3:49 AM, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> I am trying to recover a XFS partition (or series of partitions) where
> the main superblock was corrupted, and I see that there are multiple
> superblock copies. I'd like to guess the partition start and size
> also.

so I guess you mean that the partition table was corrupted as well?

> I see that the partition size can be calculated with sb_blocksize* sb_dblocks
> 
> But what about the partition start? I think I can guess it based in
> the position of the found superblocks.
> 
> Any ideas where is the code that writes to disk those backup
> superblocks? So far to me it looks like that their position is
> calculated as disk_size / 4 rounded (nearest rounding?) to a multiple
> of sb_blocksize, but having the exact code part would be better of
> course =) Or even better, a list of backup superblock positions...

How hard have you tried looking?  ;)

In xfsprogs, you can find this if you search for "backup":

" set allocation group superblock\n"
"\n"
" Example:\n"
"\n"
" 'sb 7' - set location to 7th allocation group superblock, set type to 'sb'\n"
"\n"
" Located in the first sector of each allocation group, the superblock\n"
" contains the base information for the filesystem.\n"
" The superblock in allocation group 0 is the primary.  The copies in the\n"
" remaining allocation groups only serve as backup for filesystem recovery.\n"
" The icount/ifree/fdblocks/frextents are only updated in superblock 0.\n"

The on-disk structure document describes the same thing:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Allocation_Groups.html#Superblocks

IOWs: there are superblocks in each allocation group.
They are located in the first sector of each AG, therefore the primary is
in sector 0 of the filesystem, and the secondaries are evenly spaced,
at the first sector of of AGs 1, 2, 3, 4, etc.

If you read the mkfs manpage, you'll see that ag size can be specified at
mkfs time, so there is no universal answer.  However, the default is to
split the filesystem into 4 AGs, unless the filesystem is > 1T, in which case
it will create 1T allocation groups.

If you want to look at the actual code that makes these geometry calculations,
you can find it by tracing through mkfs, paying attention to the variables which
get set by the agcount and/or agsize options.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
