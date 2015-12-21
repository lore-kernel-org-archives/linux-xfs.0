Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A573229DF5
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28794AC005
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 11:37:28 -0800 (PST)
Received: from smtp.estcard.ee (smtp.estcard.ee [194.204.11.100]) by
	cuda.sgi.com with ESMTP id Q1B4O0xbcXbIIkTH (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Dec 2015 11:37:25 -0800 (PST)
Received: from fserv.internal ([192.168.15.3])
	by smtp.estcard.ee with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.73) (envelope-from <kalts@estpak.ee>) id 1aB6Gq-0005un-9E
	for xfs@oss.sgi.com; Mon, 21 Dec 2015 21:37:24 +0200
Received: from myhakas.internal ([192.168.21.128] helo=myhakas.in.estcard.ee)
	by fserv.internal with esmtp (Exim 4.69)
	(envelope-from <kalts@estpak.ee>) id 1aB6Gq-0001xq-7B
	for xfs@oss.sgi.com; Mon, 21 Dec 2015 21:37:24 +0200
Date: Mon, 21 Dec 2015 21:37:24 +0200
From: Vallo Kallaste <kalts@estpak.ee>
Subject: Re: State of ext4 auto_da_alloc-like workarounds in XFS
Message-ID: <20151221193724.GD482@hape.internal>
References: <20151221183726.GC482@hape.internal> <5678497F.1020104@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5678497F.1020104@sandeen.net>
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

On Mon, Dec 21, 2015 at 12:48:31PM -0600, Eric Sandeen <sandeen@sandeen.net> wrote:

[...]
> > I'd like to know the current state of ext4 auto_da_alloc-like workarounds in XFS,
> > particularly for RHEL7. Considering the two cases in
> > https://en.wikipedia.org/wiki/Ext4#Delayed_allocation_and_potential_data_loss
> > is XFS behaving the same as ext4, both mounted with default options?
> 
> The sync-on-close-after-file-got-truncated case has been handled since 2007; see
> 
> https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/commit/?id=ba87ea699ebd9dd577bf055ebc4a98200e337542
> 
> The sync-after-rename behavior was suggested and rejected for xfs, see
> 
> http://marc.info/?t=139845506300002&r=1&w=2
> 
> If you'd like to add this information to the XFS wiki, please do so!

Thanks, this is an exemplary answer, not to mention lightning fast as well!

I would consider if Wiki had at http://xfs.org/index.php/Special:RequestAccount page:
* Privacy policy http://xfs.org/index.php/XFS.org:Privacy_policy
* Terms of Service http://xfs.org/index.php?title=XFS.org:Terms_of_Service&action=edit&redlink=1

The latter being something I must read and agree on before I can request a user
account.

BR,
-- 
Vallo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
