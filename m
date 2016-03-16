Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB4907CDF
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 19:34:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4564EAC001
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 17:34:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9DYNztOCb7FP46xK for <xfs@oss.sgi.com>;
	Tue, 15 Mar 2016 17:34:44 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0A21E481F
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 19:34:42 -0500 (CDT)
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E8AA22.7080301@sandeen.net>
Date: Tue, 15 Mar 2016 19:34:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
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

On 3/15/16 6:08 PM, Chris Murphy wrote:
> Is this expected? File system continues to work OK, sha256sum on the
> single file on this fs matches the source, but the metadata corruption
> messages are a bit scary so figured I'd ask about it.
> 
> Filesystem created with
> xfsprogs-4.3.0-1.fc23
> kernel-4.4.4-300.fc23.x86_64
> 
> mkfs.xfs defaults used on an LVM thinly provisioned volume on a single
> spinning disk.
> 
> # xfs_info /dev/mapper/VG-testxfs
> meta-data=/dev/mapper/VG-testxfs isize=512    agcount=23, agsize=399984 blks
                                                ^^^^^^^^^^

It seems that you left a growfs step out of it, where does that come in
to the testcase?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
