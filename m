Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p25Nvigg008209 for <xfs@oss.sgi.com>; Sat, 5 Mar 2011 17:57:45 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2169A1AFD1C0
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2011 16:00:34 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id 8zJaPc6TtgBgyvYR for
	<xfs@oss.sgi.com>; Sat, 05 Mar 2011 16:00:34 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1Pw1Oj-0006ZJ-DY
	for xfs@oss.sgi.com; Sun, 06 Mar 2011 00:00:33 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1Pw1Oj-0003YA-7F
	for xfs@oss.sgi.com; Sun, 06 Mar 2011 00:00:33 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1Pw1Oj-0007rx-5y
	for xfs@oss.sgi.com; Sun, 06 Mar 2011 01:00:33 +0100
Date: Sun, 6 Mar 2011 01:00:33 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: git xfsprogs don't build
Message-ID: <20110306000033.GA14083@schmorp.de>
References: <20110304163608.GB2030@schmorp.de>
	<20110305005253.GA11865@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110305005253.GA11865@infradead.org>
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
To: xfs@oss.sgi.com

On Fri, Mar 04, 2011 at 07:52:53PM -0500, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 04, 2011 at 05:36:08PM +0100, Marc Lehmann wrote:
> > That almost certainly means somebody tried to build a shared object or
> > library with some object file compiled without -fPIC.
> 
> That function indeed doesn't exist in non-debug builds.  But by default
> we do not build xfsprogs that way.

-fPIC isn't a function, it tells gcc to not generate text relocations -
these are not supported on linux amd64.

> For now make sure to not have
> -DNDEBUG in your CFLAGS, I'll make sure we get a proper fix commited.

Well, I didn't have -DNDEBUG in my CFLAGS, but libxfs/Makefile and
libxlog/Makefile apparently had them. After removing them, I indeed do not
get the linker issue on amd64, but similar errors as on ia32:

http://ue.tst.eu/1b84c67209430c03b238b48eae7da108.txt

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
