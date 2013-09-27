Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A874E7F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 07:47:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D104304066
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 05:47:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LvPxeP9IznZlqNOj for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 05:47:17 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8RClGVB009959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:47:17 -0400
Received: from orion.maiolino.org (ovpn-113-161.phx2.redhat.com [10.3.113.161])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8RClDih017838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:47:16 -0400
Date: Fri, 27 Sep 2013 09:47:13 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: free inodes remaining in 1tb
Message-ID: <20130927124712.GB22320@orion.maiolino.org>
References: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
	<20130927010847.GW26872@dastard>
	<20130927081844.GA14996@wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130927081844.GA14996@wombat.san-francisco.ca.us>
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

Hi,

> On 2013-09-26, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> > bear in mind though that are some applications that can't read 64bit
> > inodes.
> 
> I know that NFS has some issues (documented in the XFS FAQ).  Do you
> know offhand of any other examples?
> 
My apologies, I'm not a heavy user of applications that handle file's inodes.
What I can tell you is that any application that might need to handle file's
inodes would be worth to check if they can handle 64bit inodes, for example,
some backup applications use to handle inodes for some reason (read it as 'I
have no idea how these backup apps works' :), and I've seen some reports about
problems with backup applications for this reason some time ago, but can't
really point you out anything specific.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
