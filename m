Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB33n82S013254 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:49:10 -0600
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125140553.GA16553@infradead.org>
	<492CA245.3000709@sgi.com> <20081126032710.GA19523@infradead.org>
Date: Wed, 03 Dec 2008 14:48:57 +1100
In-Reply-To: <20081126032710.GA19523@infradead.org> (Christoph Hellwig's
	message of "Tue, 25 Nov 2008 22:27:10 -0500")
Message-ID: <ncctz9llxzq.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Nov 26, 2008 at 12:11:33PM +1100, Lachlan McIlroy wrote:
>
>> Christoph Hellwig wrote:
>> > Looking over the -dev tree, can you please revert
>> > 
>> > 	http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=c79ae33eebac1c15aa435fb77362fdc5eff2be4d> > 
>> > All this wasn't needed in the old ptrace tree either, no need to carry it forward.
>> 
>> Is this code needed for the BSD port?
>
> According to Russell it may be need, but he'll probably need a newer
> version than the one check-ed in once he resyncs.  And he'll have his
> own support dir with the rest of the BSD code.
>
>> There may be other code that can be removed too.  We moved a lot of the code
>> that existed only in ptools into the xfs-dev branch so that branch and ptools
>> are in sync.  This allows us to automatically merge changes back to the old
>> ptools tree (yes it still lives).  Any merge failures will now be handled
>> between git branches and not between different scms.
>
> The xfs-dev also fortunately doesn't have the modular quota code.  So
> for both these I'd suggest removing them from the ptools tree, too.
>
>
> Also
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=ca830fdf6231d0683f4ea4e9223e234c3a509063doesn't seem to be needed.  None of those symbols seems to be used by
> either dmapi or xfsidbg, the only two modules using xfs symbols in the
> tree.

That's exactly why it's there, the revertion is actually moving from
what was in ptools to something sane.
-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
