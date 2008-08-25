Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 08:01:36 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PF1Yhp022445
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 08:01:34 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C40C91A41EBB
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 08:02:55 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.187]) by cuda.sgi.com with ESMTP id pVAmPogpOOlCHI4E for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 08:02:55 -0700 (PDT)
Date: Mon, 25 Aug 2008 17:02:53 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: agi unlinked bucket
In-Reply-To: <48B22659.9050301@sgi.com>
Message-ID: <alpine.DEB.1.10.0808251658330.26780@sheep.housecafe.de>
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de> <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de> <20080825003929.GN5706@disturbed> <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de> <48B22659.9050301@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On Mon, 25 Aug 2008, Timothy Shimmin wrote:
> So in your case, it looks like in AG#0 on the 26th element of the array it is pointing
> to inode# 20208090. Which would infer that inode#20208090 was unlinked
> but still had references to it at the time the filesystem was not cleanly
> unmounted (power loss, crash etc..). It looks like for the root directory inode #128
> it has a count of 335 but it is finding 336 entries.

Thanks for this very interesting explanation, Timothy. I finally ran 
xfs_repair on the filesystem, twice, now everything seems to be in good 
shape.

If you guys are interested: http://nerdbynature.de/bits/2.6.27-rc3/fsck_md3.log


Thanks,
Christian.
-- 
BOFH excuse #363:

Out of cards on drive D:
