Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81CBD7F69
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 21:46:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0EB03AC003
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 19:46:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JsJKNKPCtM5dHzD7 for <xfs@oss.sgi.com>;
	Sat, 30 Aug 2014 19:46:24 -0700 (PDT)
Message-ID: <54028C7F.4040706@sandeen.net>
Date: Sat, 30 Aug 2014 21:46:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Run out of inodes?
References: <54005108.1020203@inserm.fr>	<20140829114806.GA17610@bfoster.bfoster>
	<5400802C.5050005@inserm.fr>	<54009603.9050404@sandeen.net>
	<8d5fff2548d35737c6cebcb1f6382e80@inserm.fr>
In-Reply-To: <8d5fff2548d35737c6cebcb1f6382e80@inserm.fr>
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
To: Samuel GRANJEAUD IR/INSERM <samuel.granjeaud@inserm.fr>, xfs@oss.sgi.com

On 8/30/14, 2:33 PM, Samuel GRANJEAUD IR/INSERM wrote:
> Enabling the inode64 option has solved the problem.
>
> Final question: could some issues appear with SAMBA?

ah, what sort of issues?

Any application which uses i.e. a 32-bit stat() interface will return -EOVERFLOW on a 64-bit inode.

http://sandeen.net/wordpress/computers/the-world-wants-32-bit-inodes/
http://blog.fmeh.org/2013/05/11/does-the-world-need-32-bit-inodes/

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
