Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B3467F53
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 19:48:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79B248F804B
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:48:48 -0700 (PDT)
Received: from mail04.lsn.net (mail04.lsn.net [66.90.130.138]) by cuda.sgi.com
	with ESMTP id Nc165FHZIFheKILV for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 17:48:44 -0700 (PDT)
Message-ID: <540F9FE9.7070500@mygrande.net>
Date: Tue, 09 Sep 2014 19:48:41 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
	<540F7E37.7020500@sandeen.net>
In-Reply-To: <540F7E37.7020500@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/2014 5:24 PM, Eric Sandeen wrote:
> On 9/9/14 11:03 AM, Sean Caron wrote:
>
>> Barring rare cases, xfs_repair is bad juju.
>
> No, it's not.  It is the appropriate tool to use for filesystem repair.
>
> But it is not the appropriate tool for recovery from mangled storage.

	It's not all that mangled.  Out of over 52,000 files on the backup 
server array, only 5758 were missing from the primary array, and most of 
those were lost by the corruption of just a couple of directories, where 
every file in the directory was lost with the directory itself.  Several 
directories and a scattering of individual files were deleted with 
intent prior to the failure but not yet purged from the backup.  Most 
were small files - only 29 were larger than 1G.  All of those 5758 were 
easily recovered.  The only ones remaining at issue are 3 files which 
cannot be read, written or deleted.  The rest have been read and 
checksums sucessfully computed and compared.  With only 50K files in 
question, I am confidant any checksum collisions are of insignificant 
probability.  Someone is going to have to do a lot of talking to 
convince me rsync can read two copies of what should be the same data 
and come up with the same checksum value for both, but other 
applications would be able to successfully read one of the files and not 
the other.

	I really don't think Draconian measures are required.  Even if it turns 
out they are, the existence of the backup allows for a good deal of 
fiddling with the main filesystem before one is compelled to give up and 
start fresh.  This especially since a small amount of the data on the 
main array had not yet been backed up to the secondary array.  These 
e-mails, for example.  The rsync job that backs up the main array runs 
every morning at 04:00, so files created that day were not backed up, 
and for safety I have changed the backup array file system to read-only, 
so nothing created since is backed up.


> I've actually been running a filesystem fuzzer over xfs images, randomly
> corrupting data and testing repair, 1000s of times over.  It does
> remarkably well.
>
> If you scramble your raid, which means your block device is no longer
> an xfs filesystem, but is instead a random tangle of bits and pieces of
> other things, of course xfs_repair won't do well, but it's not the right
> tool for the job at that stage.

	This is nowhere near that stage.  A few sectors here and there were 
lost because 3 drives were kicked from the array while write operations 
were underway.  I had to force re-assemble the array, which lost some 
data.  The vast majority of the data is clearly intact, including most 
of the file system structures.  Far less than 1% of the data was lost or 
corrupted.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
