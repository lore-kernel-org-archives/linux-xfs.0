Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 017E67CBE
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 23:38:02 -0600 (CST)
Date: Mon, 3 Feb 2014 23:37:58 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [RFC 00/17] RFC parent inode pointers.
Message-ID: <20140204053757.GA19307@sgi.com>
References: <20140115220012.624438534@sgi.com> <20140116055607.GR3431@dastard>
	<52D99FD2.6000601@sgi.com> <20140118031247.GE18112@dastard>
	<52E6B67B.6070001@sgi.com> <20140128030040.GG2212@dastard>
	<20140128220230.GF13953@sgi.com> <20140204000944.GX13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204000944.GX13997@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 11:09:44AM +1100, Dave Chinner wrote:
| On Tue, Jan 28, 2014 at 04:02:30PM -0600, Geoffrey Wehrman wrote:
| > On Tue, Jan 28, 2014 at 02:00:40PM +1100, Dave Chinner wrote:
| > | On Mon, Jan 27, 2014 at 01:41:47PM -0600, Mark Tinguely wrote:
| > | > 2) Add the filename to EA. Not a fan, but I will ask but if DMF needs it
| > | >    for performance then it has to be done. My point was this assumes
| > | >    that we can keep all the links' EA entries inline in the inode. A
| > | >    couple 255 character files or several links of modest sized filenames
| > | >    would negate that assumption. I tried to minimize the EA entries to
| > | >    keep them inline in the inode. I will talk to the DMF group.
| > | 
| > | Actually, I made the point about DMF needing them inline performance
| > | because that's an argument SGI might find persuasive. What I didn't
| > | say just then is that *I* need them inline, too, as online directory
| > | tree scrubbing needs to be able to do bulks scans, as does
| > | xfs_repair. However, I have idefinitely said this before in previous
| > | parent poitner discussions, so it should be no surprise here...
| > 
| > I appologize in advance for my ignorance.  What is "online directory
| > tree scrubbing" and how does it benefit from parent inode pointers?
| 
| It will be a kernel thread that walks the directory tree
| periodically verifying that all inodes are reachable and that the
| directory tree is intact. It's the same principle as RAID array
| media scrubbing - proactive detection of errors that could cause
| failures and repairing them before an error is delivered to the
| application. The reason for wanting parent pointers is that it
| enables immediate repair of most corruptions as the scrubbing
| detects them without requiring duplicate copies of the metadata.
| 
| IOWs, parent pointers are a fundamental part of bringing on-line
| repair functionality to XFS. While parent pointers are not directly
| mentioned in this document:
| 
| http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corruption
| 
| There is a section on reverse mapping for used blocks and how to use
| that for online repair of detected damage. Parent pointers provide
| reverse mappings for the directory structure, and hence provide the
| same functionality. Parent pointers also means that if we get an IO
| error in a block in a file, we can identify the owner of the block
| by full path and offset into the file where the error has
| occurred...
| 
| The v5 metadata format has an owner field in all metadata that has a
| single parent object for keeping such parent information, and it is
| intended for improving scrub-based validation and for identifying
| the owner of lost metadata blocks to improve recover from errors.
| i.e. reverse mapping is a one of the fundamental architectural
| requirements underlying the v5 metadata changes.
| 
| The two missing pieces are the parent pointers for directory
| structure reverse mapping, and an AGF reverse mapping btree to
| enable arbitrary block->owner lookups. I have prototype code for the
| AGF rmap btree, and the parent pointers provide that functionality
| for the directory structure. With both of these implemented, we will
| be able to do fully-online filesystem metadata validity checking
| equivalent to 'xfs_repair -n' or better.....
| 
| Reverse block mapping and directory structure parent pointers have
| been considered necessary for robust exception handling and online
| repair since we first started thinking about the CRC metadata format
| changes....

I understand now.  Thanks for the detailed explanation!


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
