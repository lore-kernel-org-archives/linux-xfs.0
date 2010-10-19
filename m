Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JDZUSp183655 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 08:35:31 -0500
Received: from pyrimidin.rz.uni-konstanz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77EE21518CAD
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 06:51:37 -0700 (PDT)
Received: from pyrimidin.rz.uni-konstanz.de (pyrimidin.rz.uni-konstanz.de
	[134.34.240.46]) by cuda.sgi.com with ESMTP id dqNQQOsyD3BwQwX2
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 06:51:37 -0700 (PDT)
in-reply-to: 20101019014245.GN29677@dastard
From: "Markus Roth" <Markus.Roth@uni-konstanz.de>
message-id: <1eca-4cbd9f00-19-5fdb7300@218342653>
subject: Re: Performance degeneration issues
date: Tue, 19 Oct 2010 15:36:41 +0200
MIME-Version: 1.0
Reply-To: Markus Roth <Markus.Roth@uni-konstanz.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hello and thanks for your reply. 

Am Dienstag 19 Oktober 2010 03:42 CEST, Dave Chinner <david@fromorbit.com> schrieb: 
 
> What's the layout of you storage? how many disks, size, etc.
> How much RAM, number of CPUs in your server?

Server hardware is a tricky question as there are 4 different servers
I have tested XFS on. Three of those are running as a VM guest under
VMWare ESX. One is on pure hardware.

All of the servers have Xeon Processors, every CentOS installation
limited to only use 2 Cores (vCPUs in VMWare).

Listing by server (VMs flagged with a *):
    Intel(R) Xeon(TM) CPU 3.00GHz - 8GB DDR2 ECC - 2x single HDDs, no RAID, 10k rpm SAS (80 + 140GB)
*   Intel(R) Xeon(TM) MV CPU 3.20GHz - 4GB DDR2 ECC - Storage is a SAN (via FibreChannel) (90 GB exclusive)
*   Intel(R) Xeon(R) CPU 5160  @ 3.00GHz - 10GB DDR2 ECC - 2x RAID0 with 10k rpm SAS (74GB each)
*   Intel(R) Xeon(R) CPU X5560  @ 2.80GHz - 16 GB DDR3 ECC - Storage is a SAN (via FibreChannel) (80GB exclusive)

With the SANs I checked if they are under heavy load (they are not).
Of those VMs only I is situated in an environment where there is load
from other VMs.

> Using information from a 7 year old web page about how someone
> optimised their filesystem for a specific bonnie++ workload
> is not really a good place to start when it comes to real-world
> optimisation.

Well it gave me some pointers and after some thinking and testing I
ended up with those options. I have to admit that my knowledge of
XFS is based only on that and some other webpages so I wouldn't
know where and how to improve performance.

> 
> You need understand why the performance falls through the floor
> first, then work out what needs optimising. It may be that your sort
> algorithm has exponential complexity, or you are running out of RAM,
> or something else. It may not have anything at all to do with the
> filesystem.
 
It isn't really a sorting algorithm. Every file has 3 elements that can be 
used to categorise it. So the actual sorting amounts to a linear search
(read) for those elements and a move/copy&delete (after possible 
creation of 4 directories in which to sort/categorise). 
[categorisation is done in this pattern: /<unique id>/<year>/fixed/(a|b)]

After some testing it seems copy&delete is 4x slower than reading the file.

> The symptoms you describe sound like the difference between
> operation in cache vs out of cache (i.e. RAM speed vs disk speed),
> and if so then no amount of filesystem tweaking will fix it.

I see your point but I can't see much caching with inflating tar/bzip2
(and that is where XFS really shines here ...).

> However, if you describe you system and the algorithms you are using
> in more detail, we might be able to help identify the cause...

The only addition I can make to the algorithms is this:
My application is written in Java and I have tried three different approaches
to the copy & delete matter
   - java.io -> Read + immediate Write, then Delete (via Readers and Writers)
   - java.io -> renameTo (applicable not for all directories/paths)
   - java.nio -> FileChannels (transferTo)

All of which show the same issues. So my reasoning was either hardware
or FS. But seeing as the degeneration als happens with the SANs I thought
it might be more of a FS specific issue.

Application is mostly single threaded (at least at the point I'm having
trouble with)

If you would like more information feel free to ask.

Thanks and Greetings from Germany,
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
