Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD23D7CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 10:21:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48F19AC00D
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 08:20:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A2IyRdknzq5R317C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Jul 2016 08:20:56 -0700 (PDT)
Date: Fri, 29 Jul 2016 11:20:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: partition 100% full No space left on device. looks like xfs
	iscorrupted or a bug
Message-ID: <20160729152052.GB27744@bfoster.bfoster>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<20160729140330.GA27744@bfoster.bfoster>
	<8C01136A431C4B0AB9FC6A48220A7957@dinulap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8C01136A431C4B0AB9FC6A48220A7957@dinulap>
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
To: Lista Unx <lista.unx@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 29, 2016 at 05:37:19PM +0300, Lista Unx wrote:
> 
> ----- Original Message ----- From: "Brian Foster" <bfoster@redhat.com>
> To: "Lista Unx" <lista.unx@gmail.com>
> Cc: <xfs@oss.sgi.com>
> Sent: Friday, July 29, 2016 5:03 PM
> Subject: Re: partition 100% full No space left on device. looks like xfs
> iscorrupted or a bug
> 
> 
> > First and foremost, have you run 'xfs_repair -n' to see if the fs is
> > healthy? If so, the next thing I would probably try is mount from a
> > single user mode of some sort (or boot a livecd) and recheck from there
> > to rule out any OS runtime weirdness going on (open but unlinked files,
> > files hidden under mount points, etc.).
> > 
> > Brian
> > 
> 
> That's I want to do before to post here. I have access just via ssh. and
> xfs_repair require to work offline (partition to not be mounted). I do not
> have for the momment to access server using ILO (will take another few weeks
> for that) and that's the reason I post here, maybe we can coclude without
> putting server down.
> 

I guess you could kill what you can, inspect any open files with
fuser/lsof, and try to unmount as much as possible. Otherwise, I'm not
sure how far you can get until you have the ability to check the fs.
Perhaps others have more ideas...

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
