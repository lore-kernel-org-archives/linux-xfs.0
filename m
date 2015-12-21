Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0B057F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:37:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 91F838F8039
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 10:37:31 -0800 (PST)
Received: from smtp.estcard.ee (smtp.estcard.ee [194.204.11.100]) by
	cuda.sgi.com with ESMTP id zRqP7PYxC2j3kUs5 (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Dec 2015 10:37:29 -0800 (PST)
Received: from fserv.internal ([192.168.15.3])
	by smtp.estcard.ee with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.73) (envelope-from <kalts@estpak.ee>) id 1aB5Ko-0005Ax-ES
	for xfs@oss.sgi.com; Mon, 21 Dec 2015 20:37:26 +0200
Received: from myhakas.internal ([192.168.21.128] helo=myhakas.in.estcard.ee)
	by fserv.internal with esmtp (Exim 4.69)
	(envelope-from <kalts@estpak.ee>) id 1aB5Ko-0008Qk-A1
	for xfs@oss.sgi.com; Mon, 21 Dec 2015 20:37:26 +0200
Date: Mon, 21 Dec 2015 20:37:26 +0200
From: Vallo Kallaste <kalts@estpak.ee>
Subject: State of ext4 auto_da_alloc-like workarounds in XFS
Message-ID: <20151221183726.GC482@hape.internal>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: kalts@estpak.ee
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

Hi

The ext4 workaround for wrong-but-common truncate/rename cases can be found at
https://en.wikipedia.org/wiki/Ext4#Delayed_allocation_and_potential_data_loss
This is the default "auto_da_alloc" mount option.

There is no mention of similar workaround in XFS FAQ at
http://xfs.org/index.php/XFS_FAQ nor
Wiki article at http://en.wikipedia.org/wiki/XFS
I suggest adding such a section.

I have read the thread at
http://article.gmane.org/gmane.comp.file-systems.xfs.general/53366
There seems to be definite answer at the top of
http://article.gmane.org/gmane.comp.file-systems.xfs.general/53376

But besides that I found
http://article.gmane.org/gmane.linux.kernel/812588 where it's mentioned that
/--/
The bigger problem from my perspective is that XFS is only doing this for the
truncate case, and (from what I've been told) not for the rename case.
/--/

I'd like to know the current state of ext4 auto_da_alloc-like workarounds in XFS,
particularly for RHEL7. Considering the two cases in
https://en.wikipedia.org/wiki/Ext4#Delayed_allocation_and_potential_data_loss
is XFS behaving the same as ext4, both mounted with default options?

thanks,
-- 
Vallo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
