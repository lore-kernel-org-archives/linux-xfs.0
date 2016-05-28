Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 833327CB4
	for <xfs@oss.sgi.com>; Sat, 28 May 2016 08:23:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5561E304053
	for <xfs@oss.sgi.com>; Sat, 28 May 2016 06:23:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P8WGZZg2Htx9JrC6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 28 May 2016 06:23:15 -0700 (PDT)
Date: Sat, 28 May 2016 09:23:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfsrestore performance
Message-ID: <20160528132312.GA62624@bfoster.bfoster>
References: <CAPhCz3S7dvrOCqEJFvYvTQ89nUJwFxieQ5A1rShaxUb71rrNew@mail.gmail.com>
	<CAPhCz3SPomfAn68TknFW-KyEB4WXvPzXU8UVhXWqyXztNbQG+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPhCz3SPomfAn68TknFW-KyEB4WXvPzXU8UVhXWqyXztNbQG+Q@mail.gmail.com>
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
To: xfs.pkoch@dfgh.net
Cc: xfs@oss.sgi.com

On Sat, May 28, 2016 at 11:25:32AM +0200, xfs.pkoch@dfgh.net wrote:
> Dear XFS experts,
> 
> I checked the situation this morning:
> 
> ....
> xfsdump: status at 10:25:53: 473543/7886560 files dumped, 1.3% data dumped,
> 76211 seconds elapsed
> xfsdump: status at 10:35:46: 478508/7886560 files dumped, 1.3% data dumped,
> 76804 seconds elapsed
> 
> and decided to stop the process. With this kind of speed xfsdump |
> xfsrestore
> will need more than one month. Something must be seriously wrong here.
> 

I don't have much experience working with xfsdump so I couldn't really
comment here without spending some significant time playing around with
it. Hopefully somebody else can chime in on this.

> I see two options: Use rsync again to copy the data from the 14TB xfs
> filesystem to the new 20TB xfs filesystem. This won't be finished
> this weekend.
> 

Could you temporarily promote your 14TB fs to production in order to
make the data available while an rsync process migrates the data back
over to the properly formatted 20TB fs?

> Or use dd to copy the 14TB XFS filesystem into the 20TB volume and
> then grow the filesystem.
> 
> dd runs at 300MB/sec that's approx 1TB per hour, so I decided to go this
> way.
> 
> So here's another question: The new filesystem will run on a 20 disk raid10
> volume and was copied from a 16 disk raid5 volume. So swidth will be wrong.
> Also all the data will be within the first 15TB.
> 
> What should I do to fix this? Or will xfs_growfs fix it automatically?
> 

xfs_growfs will add more allocation groups based on the size of the
current storage. It won't reallocate existing files or anything of that
nature.

You can't change the stripe unit/width parameters after the fact, afaik.
The only way to accomplish this appropriately that I can think of is to
forcibly reformat the temporary filesystem with the settings targeted to
the longer term storage, reimport the data from the production volume
and then copy over the raw block device.

Brian

> Regards
> 
> Peter Koch

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
