Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED4378047
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 09:06:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 785DEAC002
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 07:06:51 -0800 (PST)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id GBMeTXVNhkyOABha (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Feb 2013 07:06:50 -0800 (PST)
Message-ID: <511E4F00.2010703@profihost.ag>
Date: Fri, 15 Feb 2013 16:06:40 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: 32bit apps and inode64
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard>
In-Reply-To: <20120509070450.GP5091@dastard>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello list,

i've discovered some problems on a host with a disk > 1TB. We've some
binary 32bit applications which are not able to read some directory
anymore after we've formated and installed the system using vanilla
3.7.7 kernel.

Right now we're using 3.0.61 kernel on this host - so 64bit apps work
well and newly created files get 32bit inode numbers as inode64 is not
the default.

Is there a way to find / get all 64bit inode files / dies and convert
them back to 32bit without a reinstall?

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
