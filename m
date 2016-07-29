Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BC267CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 09:37:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF2B9AC006
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 07:37:20 -0700 (PDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id wapfmJtfhIVmKQ4A
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2016 07:37:18 -0700 (PDT)
Received: by mail-wm0-f50.google.com with SMTP id q128so292634022wma.1
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 07:37:18 -0700 (PDT)
Message-ID: <8C01136A431C4B0AB9FC6A48220A7957@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<20160729140330.GA27744@bfoster.bfoster>
Subject: Re: partition 100% full No space left on device. looks like xfs
	iscorrupted or a bug
Date: Fri, 29 Jul 2016 17:37:19 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com


----- Original Message ----- 
From: "Brian Foster" <bfoster@redhat.com>
To: "Lista Unx" <lista.unx@gmail.com>
Cc: <xfs@oss.sgi.com>
Sent: Friday, July 29, 2016 5:03 PM
Subject: Re: partition 100% full No space left on device. looks like xfs 
iscorrupted or a bug


> First and foremost, have you run 'xfs_repair -n' to see if the fs is
> healthy? If so, the next thing I would probably try is mount from a
> single user mode of some sort (or boot a livecd) and recheck from there
> to rule out any OS runtime weirdness going on (open but unlinked files,
> files hidden under mount points, etc.).
>
> Brian
>

That's I want to do before to post here. I have access just via ssh. and 
xfs_repair require to work offline (partition to not be mounted). I do not 
have for the momment to access server using ILO (will take another few weeks 
for that) and that's the reason I post here, maybe we can coclude without 
putting server down.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
