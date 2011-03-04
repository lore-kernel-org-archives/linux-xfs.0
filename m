Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24HRWJY179403 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 11:27:33 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44E11A9B9A8
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 09:30:23 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id ZVAECjRFDenDCCks for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 09:30:23 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvYpa-00033e-7R
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 17:30:22 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvYpa-0001UG-40
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 17:30:22 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1PvYpa-00024T-1E
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 18:30:22 +0100
Date: Fri, 4 Mar 2011 18:30:22 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: corruption, xfs_repair 3.1.4 segfaults, xfs_repair 2.9.8 works
Message-ID: <20110304173021.GA7912@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D71001D.2040506@sandeen.net>
	<20110304121407.065d9f17@harpe.intellique.com>
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

On Fri, Mar 04, 2011 at 12:14:07PM +0100, Emmanuel Florac <eflorac@intellique.com> wrote:
> Lenny's xfs_repair (v 2.9.x IIRC). Just in case, it may do better.

It did, and with a lot fewer scary messages (no -P or -m was necessary):

http://ue.tst.eu/f3860347ab2147d87fdf8f961d6d4358.txt

afterwards, I had the contents of the single directory that caused issues
in lost+found, and no unreadable directories left.

So definitely a regression in 3.1.4.

Thanks a lot for your all your input - I will reformat the partition soon
and restore the files, assuming that the lenny xfs_repair destroyed any
evidence.

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
