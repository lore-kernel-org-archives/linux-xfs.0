Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4M80BR8194739 for <xfs@oss.sgi.com>; Sun, 22 May 2011 03:00:12 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 408F31E32B61
	for <xfs@oss.sgi.com>; Sun, 22 May 2011 01:00:10 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 1DqtzcofJs0P2OA6 for
	<xfs@oss.sgi.com>; Sun, 22 May 2011 01:00:10 -0700 (PDT)
Date: Sun, 22 May 2011 09:59:55 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110522075955.GA2341@citd.de>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
	<20110522020024.GZ32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110522020024.GZ32466@dastard>
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
Cc: Marc Lehmann <schmorp@schmorp.de>, xfs@oss.sgi.com

On 22.05.2011 12:00, Dave Chinner wrote:
> 
> I don't really care what you think the problem is based on what
> you've read in this email thread, or for that matter how you think
> we should fix it. What I really want is your test cases that
> reproduce the problem so I can analyse it for myself. Once I
> understand what is going on, then we can talk about what the real
> problem is and how to fix it.

What would interest me is why the following creates files with large 
preallocations.

cp -a <somedir> target
rm -rf target
cp -a <somedir> target

After the first copy everything looks normal, `du` is about the 
original value.

After the second run a `du` shows a much higher value, until the 
preallocation is shrunk away.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
