Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 52A6D7F3F
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 16:49:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2829AC002
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 14:49:47 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id Z0M7beuhk3HSjGAs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 14:49:46 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1UHhwU-0000eU-4t
	for linux-xfs@oss.sgi.com; Mon, 18 Mar 2013 22:50:06 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 22:50:06 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 22:50:06 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: mount XFS partition fail after repair when uquota and gquota
	are used
Date: Mon, 18 Mar 2013 14:47:15 -0700
Message-ID: <3kek1axeq4.ln2@goaway.wombat.san-francisco.ca.us>
References: <1363600796196-34996.post@n7.nabble.com>
	<20130318164743.GC22182@sgi.com> <51477035.7070200@epfl.ch>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2013-03-18, Guillaume Anciaux <guillaume.anciaux@epfl.ch> wrote:
> I wish I could do this but the result of "meta_dump /dev/sdb1" for the 
> partition containing 6.9T of data is promising to be quite large. Are 
> there special options I should use to extract only the information that 
> you would need to investigate my problem ?

The actual output of xfs_metadump should be quite small even for a
multiterabyte filesystem.  In 2011 I did a metadump of an 11TB
filesystem, and the result was a 7GB file.  You might not want to post
that to a mailing list, of course, but it should still be easier to
schlepp around if needed.


--keith


-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
