Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B5307F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:48:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9AF63AC002
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 10:48:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Wvsnqyc7KFf4vg0a for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 10:48:32 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0491A63C5A9F
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:48:31 -0600 (CST)
Subject: Re: State of ext4 auto_da_alloc-like workarounds in XFS
References: <20151221183726.GC482@hape.internal>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5678497F.1020104@sandeen.net>
Date: Mon, 21 Dec 2015 12:48:31 -0600
MIME-Version: 1.0
In-Reply-To: <20151221183726.GC482@hape.internal>
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

On 12/21/15 12:37 PM, Vallo Kallaste wrote:
> Hi
> 
> The ext4 workaround for wrong-but-common truncate/rename cases can be found at
> https://en.wikipedia.org/wiki/Ext4#Delayed_allocation_and_potential_data_loss
> This is the default "auto_da_alloc" mount option.
> 
> There is no mention of similar workaround in XFS FAQ at
> http://xfs.org/index.php/XFS_FAQ nor
> Wiki article at http://en.wikipedia.org/wiki/XFS
> I suggest adding such a section.
> 
> I have read the thread at
> http://article.gmane.org/gmane.comp.file-systems.xfs.general/53366
> There seems to be definite answer at the top of
> http://article.gmane.org/gmane.comp.file-systems.xfs.general/53376
> 
> But besides that I found
> http://article.gmane.org/gmane.linux.kernel/812588 where it's mentioned that
> /--/
> The bigger problem from my perspective is that XFS is only doing this for the
> truncate case, and (from what I've been told) not for the rename case.
> /--/
> 
> I'd like to know the current state of ext4 auto_da_alloc-like workarounds in XFS,
> particularly for RHEL7. Considering the two cases in
> https://en.wikipedia.org/wiki/Ext4#Delayed_allocation_and_potential_data_loss
> is XFS behaving the same as ext4, both mounted with default options?

The sync-on-close-after-file-got-truncated case has been handled since 2007; see

https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/commit/?id=ba87ea699ebd9dd577bf055ebc4a98200e337542

The sync-after-rename behavior was suggested and rejected for xfs, see

http://marc.info/?t=139845506300002&r=1&w=2

If you'd like to add this information to the XFS wiki, please do so!

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
