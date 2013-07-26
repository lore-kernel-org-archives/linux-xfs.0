Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DD0D7F51
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 02:23:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63F183040A4
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 00:23:42 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id mZJmeC92uHhAtHn5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 00:23:41 -0700 (PDT)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <jbr@squareup.com>) id 1V2cNI-0006Vw-Hw
	for xfs@oss.sgi.com; Fri, 26 Jul 2013 00:23:40 -0700
Date: Fri, 26 Jul 2013 00:23:40 -0700 (PDT)
From: jbr <jbr@squareup.com>
Message-ID: <1374823420041-35002.post@n7.nabble.com>
Subject: understanding speculative preallocation
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I'm looking for general documentation/help with the speculative
preallocation feature in xfs.  So far, I haven't really been able to find
any definitive, up to date documentation on it.

I'm wondering how I can find out definitively which version of xfs I am
using, and what the preallocation scheme in use is.

We are running apache kafka on our servers, and kafka uses sequential io to
write data log files.  Kafka uses, by default, a maximum log file size of
1Gb.  However, most of the log files end up being 2Gb, and thus the disk
fills up twice as fast as it should.

We are using xfs on CentOS 2.6.32-358.  Is there a way I can know which
version of xfs is built into this version of the kernel?  What preallocation
schedule does it use?  If I do a xfs_info -V, it reports 3.1.1.

We are using xfs (mounted with no allocsize specified).  I've seen varying
info suggesting this means it either defaults to an allocsize of 64K (which
doesn't seem to match my observations), or that it will use dynamic
preallocation.

I've also seen hints (but no actual canonical documentation) suggesting that
the dynamic preallocation works by progressively doubling the current file
size (which does match my observations).

What I'm not clear on, is the scheduling for the preallocation. At what
point does it decide to preallocate the next doubling of space.  Is it when
the current preallocated space is used up, or does it happen when the
current space is used up within some threshold.  What I'd like to do, is
keep the doubling behavior in tact, but have it capped so it never increases
the file beyond 1Gb.  Is there a way to do that?  Can I trick the
preallocation to not do a final doubling, if I cap my kafka log files at
say, 900Mb (or some percentage under 1Gb)?

There are numerous references to an allocation schedule like this:

freespace       max prealloc size
  >5%             full extent (8GB)
  4-5%             2GB (8GB >> 2)
  3-4%             1GB (8GB >> 3)
  2-3%           512MB (8GB >> 4)
  1-2%           256MB (8GB >> 5)
  <1%            128MB (8GB >> 6)

I'm just not sure I understand what this is telling me.  It seems to tell me
what the max prealloc size is, with being reduced if the disk is nearly
full.  But it doesn't tell me about the progressive doubling in
preallocation (I assume up to a max of 8Gb).  Is any of this configurable? 
Can we specify a max prealloc size somewhere?

The other issue seems to be that after the files are closed (from within the
java jvm), they still don't seem to have their pre-allocated space
reclaimed.  Are there known issues with closing the files in java not
properly causing a flush of the preallocated space?

Any help pointing me to any documentation/user guides which accurately
describes this would be appreciated!

Thanks,

Jason



--
View this message in context: http://xfs.9218.n7.nabble.com/understanding-speculative-preallocation-tp35002.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
