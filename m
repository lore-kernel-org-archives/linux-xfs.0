Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48AD87F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 10:17:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09E94304043
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 08:17:21 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id BMTzieNDtR0kYvRB for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 08:17:18 -0700 (PDT)
Date: Fri, 20 Mar 2015 11:17:18 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150320151718.GD2036@fieldses.org>
References: <20150317213654.GE29843@fieldses.org> <5509C0FD.70309@Netapp.com>
	<20150318185545.GF8818@fieldses.org> <5509E27C.3080004@Netapp.com>
	<20150318205554.GA10716@fieldses.org> <5509E824.6070006@Netapp.com>
	<20150318211144.GB10716@fieldses.org>
	<OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
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
To: Marc Eshel <eshel@us.ibm.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Anna Schumaker <Anna.Schumaker@netapp.com>, linux-nfs-owner@vger.kernel.org

Maybe this is a question for xfs developers.

So, we have a new READ_PLUS call that's basically just a version of READ
optimized for sparse files:

	http://tools.ietf.org/html/draft-ietf-nfsv4-minorversion2-33#section-15.10

It allows an NFS server to return either file data (like a normal READ
call) or, at the server's discretion, records saying "this range of the
data is all zeroes".

Anna tried implementing READ_PLUS for knfsd using
vfs_llseek(.,.,SEEK_HOLE) followed by an ordinary read if that
determines we're not at a hole.

(Very) preliminary results suggest that's slower than a plain READ for
an xfs file with no holes.  (And *much* slower in the ext4 case for some
reason.)

Is that expected, and should we be doing this some other way instead?

--b.

On Thu, Mar 19, 2015 at 09:28:09AM -0700, Marc Eshel wrote:
> linux-nfs-owner@vger.kernel.org wrote on 03/19/2015 08:36:27 AM:
> 
> > From: "J. Bruce Fields" <bfields@fieldses.org>
> > To: Marc Eshel/Almaden/IBM@IBMUS
> > Cc: Anna Schumaker <Anna.Schumaker@netapp.com>, linux-
> > nfs@vger.kernel.org, linux-nfs-owner@vger.kernel.org
> > Date: 03/19/2015 08:36 AM
> > Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple 
> segments
> > Sent by: linux-nfs-owner@vger.kernel.org
> > 
> > On Thu, Mar 19, 2015 at 08:00:05AM -0700, Marc Eshel wrote:
> > > linux-nfs-owner@vger.kernel.org wrote on 03/18/2015 02:11:44 PM:
> > > > From: "J. Bruce Fields" <bfields@fieldses.org>
> > > > On Wed, Mar 18, 2015 at 05:03:32PM -0400, Anna Schumaker wrote:
> > > > > On 03/18/2015 04:55 PM, J. Bruce Fields wrote:
> > > > > > On Wed, Mar 18, 2015 at 04:39:24PM -0400, Anna Schumaker wrote:
> > > > > >>       |  v4.1  |  v4.2
> > > > > >> ------+--------+-------
> > > > > >> data  | 0.764s | 1.343s
> > > > > > 
> > > > > > That's too bad.  Non-sparse files are surely still a common case 
> and
> > > > > > we'd like to not see a slowdown there....  I wonder if we can 
> figure 
> > > out
> > > > > > where it's coming from?
> > > > > 
> > > > > That's a good question, especially since the 1G file didn't double
> > > > this time.  Maybe a VM quirk?
> > > > 
> > > > We definitely need to figure it out, I think.  If we can't make
> > > > READ_PLUS perform as well as READ (or very close to it) in the
> > > > non-sparse case then I don't think we'll want it, and as Trond 
> suggested
> > > > we may want to consider something more fiemap-like instead.
> > > 
> > > Testing Anna's NFS client with the Ganesha NFS server and GPFS file 
> system 
> > > shows the same numbers for READ with v4.1 and READ_PLUS with v4.2 of a 
> 
> > > data file. Using sparse files READ_PLUS is 5 times faster than READ.
> > 
> > Thanks!  Is it possible to report the exact numbers?
> 
> This is a copy of a 100M file. 
> 
> [root@fin16 ~]# umount /mnt
> [root@fin16 ~]# mount -t nfs4 -o minorversion=1 9.1.74.120:/gpfsA /mnt
> [root@fin16 ~]# time cp /mnt/100M /dev/null
> 
> real    0m1.597s
> user    0m0.000s
> sys     0m0.062s
> [root@fin16 ~]# umount /mnt
> [root@fin16 ~]# mount -t nfs4 -o minorversion=2 9.1.74.120:/gpfsA /mnt
> [root@fin16 ~]# time cp /mnt/100M /dev/null
> 
> real    0m1.595s
> user    0m0.002s
> sys     0m0.057s
> 
> > 
> > Is Ganesha also implementing READ_PLUS with SEEK_HOLE/SEEK_DATA?  If so
> > then maybe the difference is the filesystem.  Might be interesting to
> > run the same sort of test with ganesha exporting xfs and/or knfsd
> > exporting GPFS.
> 
> GPFS did not implement it using SEEK it just calls the fs read and if 
> there is no data the fs returns ENODATA return code. It is not yet 
> implemented on other FSLAs
>  
> > 
> > --b.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

On Thu, Mar 19, 2015 at 09:28:09AM -0700, Marc Eshel wrote:
> linux-nfs-owner@vger.kernel.org wrote on 03/19/2015 08:36:27 AM:
> 
> > From: "J. Bruce Fields" <bfields@fieldses.org>
> > To: Marc Eshel/Almaden/IBM@IBMUS
> > Cc: Anna Schumaker <Anna.Schumaker@netapp.com>, linux-
> > nfs@vger.kernel.org, linux-nfs-owner@vger.kernel.org
> > Date: 03/19/2015 08:36 AM
> > Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple 
> segments
> > Sent by: linux-nfs-owner@vger.kernel.org
> > 
> > On Thu, Mar 19, 2015 at 08:00:05AM -0700, Marc Eshel wrote:
> > > linux-nfs-owner@vger.kernel.org wrote on 03/18/2015 02:11:44 PM:
> > > 
> > > > From: "J. Bruce Fields" <bfields@fieldses.org>
> > > > To: Anna Schumaker <Anna.Schumaker@netapp.com>
> > > > Cc: linux-nfs@vger.kernel.org
> > > > Date: 03/18/2015 02:14 PM
> > > > Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple 
> > > segments
> > > > Sent by: linux-nfs-owner@vger.kernel.org
> > > > 
> > > > On Wed, Mar 18, 2015 at 05:03:32PM -0400, Anna Schumaker wrote:
> > > > > On 03/18/2015 04:55 PM, J. Bruce Fields wrote:
> > > > > > On Wed, Mar 18, 2015 at 04:39:24PM -0400, Anna Schumaker wrote:
> > > > > >> On 03/18/2015 02:55 PM, J. Bruce Fields wrote:
> > > > > >>> On Wed, Mar 18, 2015 at 02:16:29PM -0400, Anna Schumaker 
> wrote:
> > > > > >>>> On 03/17/2015 05:36 PM, J. Bruce Fields wrote:
> > > > > >>>>> On Tue, Mar 17, 2015 at 04:07:38PM -0400, J. Bruce Fields 
> wrote:
> > > > > >>>>>> On Tue, Mar 17, 2015 at 03:56:33PM -0400, J. Bruce Fields 
> > > wrote:
> > > > > >>>>>>> On Mon, Mar 16, 2015 at 05:18:08PM -0400, Anna Schumaker 
> > > wrote:
> > > > > >>>>>>>> This patch implements sending an array of segments back 
> > > > to the client.
> > > > > >>>>>>>> Clients should be prepared to handle multiple segment 
> > > > reads to make this
> > > > > >>>>>>>> useful.  We try to splice the first data segment into the
> > > > XDR result,
> > > > > >>>>>>>> and remaining segments are encoded directly.
> > > > > >>>>>>>
> > > > > >>>>>>> I'm still interested in what would happen if we started 
> with 
> > > an
> > > > > >>>>>>> implementation like:
> > > > > >>>>>>>
> > > > > >>>>>>>    - if the entire requested range falls within a hole, 
> return 
> > > that
> > > > > >>>>>>>      single hole.
> > > > > >>>>>>>    - otherwise, just treat the thing as one big data 
> segment.
> > > > > >>>>>>>
> > > > > >>>>>>> That would provide a benefit in the case there are 
> large-ish 
> > > holes
> > > > > >>>>>>> with minimal impact otherwise.
> > > > > >>>>>>>
> > > > > >>>>>>> (Though patches for full support are still useful even if 
> only 
> > > for
> > > > > >>>>>>> client-testing purposes.)
> > > > > >>>>>>
> > > > > >>>>>> Also, looks like
> > > > > >>>>>>
> > > > > >>>>>>    xvs_io -c "fiemap -v" <file>
> > > > > >>>>>>
> > > > > >>>>>> will give hole sizes for a given <file>.  (Thanks, 
> > > > esandeen.)  Running
> > > > > >>>>>> that on a few of my test vm images shows a fair number of 
> large
> > > > > >>>>>> (hundreds of megs) files, which suggests identifying only 
> > > > >=rwsize holes
> > > > > >>>>>> might still be useful.
> > > > > >>>>>
> > > > > >>>>> Just for fun.... I wrote the following test program and ran 
> it 
> > > on my
> > > > > >>>>> collection of testing vm's.  Some looked like this:
> > > > > >>>>>
> > > > > >>>>>    f21-1.qcow2
> > > > > >>>>>    144784 -rw-------. 1 qemu qemu 8591507456 Mar 16 10:13 
> > > f21-1.qcow2
> > > > > >>>>>    total hole bytes:      8443252736 (98%)
> > > > > >>>>>    in aligned 1MB chunks: 8428453888 (98%)
> > > > > >>>>>
> > > > > >>>>> So, basically, read_plus would save transferring most of 
> thedata 
> > > even
> > > > > >>>>> when only handling 1MB holes.
> > > > > >>>>>
> > > > > >>>>> But some looked like this:
> > > > > >>>>>
> > > > > >>>>>    501524 -rw-------. 1 qemu qemu 8589934592 May 20  2014 
> > > > rhel6-1-1.img
> > > > > >>>>>    total hole bytes:      8077516800 (94%)
> > > > > >>>>>    in aligned 1MB chunks: 0 (0%)
> > > > > >>>>>
> > > > > >>>>> So the READ_PLUS that caught every hole might save a lot, 
> the 
> > > one that
> > > > > >>>>> only caught 1MB holes wouldn't help at all.
> > > > > >>>>>
> > > > > >>>>> And there were lots of examples in between those two 
> extremes.
> > > > > >>>>
> > > > > >>>> I tested with three different 512 MB files:  100% data, 100% 
> > > > hole, and alternating every megabyte.  The results were surprising:
> > > > > >>>>
> > > > > >>>>       |  v4.1  |  v4.2
> > > > > >>>> -----------------------
> > > > > >>>> data  | 0.685s |  0.714s
> > > > > >>>> hole  | 0.485s | 15.547s
> > > > > >>>> mixed |   1.283s |  0.448
> > > > > >>>>
> > > > > >>>> >From what I can tell, the 100% hole case takes so long 
> because 
> > > of the
> > > > > >>>>> SEEK_DATA call in nfsd4_encode_read_plus_hole().  I took 
> this 
> > > out to
> > > > > >>>>> trick the function into thinking that the entire file was 
> > > already a
> > > > > >>>>> hole, and runtime dropped to the levels of v4.1 and v4.2.
> > > > > >>>
> > > > > >>> Wait, that 15s is due to just one SEEK_DATA?
> > > > > >>
> > > > > >> The server is returning a larger hole than the client can read 
> > > > at once, so there are several SEEK_DATA calls made to verify that 
> > > > there are no data segments before the end of the file.
> > > > > >>
> > > > > >>>
> > > > > >>>> I wonder
> > > > > >>>>> if this is filesystem dependent?  My server is exporting 
> ext4.
> > > > > >>>
> > > > > >>> Sounds like just a bug.  I've been doing lots of 
> > > lseek(.,.,SEEK_DATA) on
> > > > > >>> both ext4 and xfs without seeing anything that weird.
> > > > > >>
> > > > > >> It looks like something weird on ext4.  I switched my exported 
> > > > filesystem to xfs:
> > > > > > 
> > > > > > Huh.  Maybe we should report a bug....
> > > > > > 
> > > > > >>
> > > > > >>       |  v4.1  |  v4.2
> > > > > >> ------+--------+-------
> > > > > >> data  | 0.764s | 1.343s
> > > > > > 
> > > > > > That's too bad.  Non-sparse files are surely still a common case 
> and
> > > > > > we'd like to not see a slowdown there....  I wonder if we can 
> figure 
> > > out
> > > > > > where it's coming from?
> > > > > 
> > > > > That's a good question, especially since the 1G file didn't double
> > > > this time.  Maybe a VM quirk?
> > > > 
> > > > We definitely need to figure it out, I think.  If we can't make
> > > > READ_PLUS perform as well as READ (or very close to it) in the
> > > > non-sparse case then I don't think we'll want it, and as Trond 
> suggested
> > > > we may want to consider something more fiemap-like instead.
> > > 
> > > Testing Anna's NFS client with the Ganesha NFS server and GPFS file 
> system 
> > > shows the same numbers for READ with v4.1 and READ_PLUS with v4.2 of a 
> 
> > > data file. Using sparse files READ_PLUS is 5 times faster than READ.
> > 
> > Thanks!  Is it possible to report the exact numbers?
> 
> This is a copy of a 100M file. 
> 
> [root@fin16 ~]# umount /mnt
> [root@fin16 ~]# mount -t nfs4 -o minorversion=1 9.1.74.120:/gpfsA /mnt
> [root@fin16 ~]# time cp /mnt/100M /dev/null
> 
> real    0m1.597s
> user    0m0.000s
> sys     0m0.062s
> [root@fin16 ~]# umount /mnt
> [root@fin16 ~]# mount -t nfs4 -o minorversion=2 9.1.74.120:/gpfsA /mnt
> [root@fin16 ~]# time cp /mnt/100M /dev/null
> 
> real    0m1.595s
> user    0m0.002s
> sys     0m0.057s
> 
> > 
> > Is Ganesha also implementing READ_PLUS with SEEK_HOLE/SEEK_DATA?  If so
> > then maybe the difference is the filesystem.  Might be interesting to
> > run the same sort of test with ganesha exporting xfs and/or knfsd
> > exporting GPFS.
> 
> GPFS did not implement it using SEEK it just calls the fs read and if 
> there is no data the fs returns ENODATA return code. It is not yet 
> implemented on other FSLAs
>  
> > 
> > --b.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
