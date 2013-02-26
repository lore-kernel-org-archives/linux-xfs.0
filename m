Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 587FA7F52
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 09:31:20 -0600 (CST)
Message-ID: <512CD581.6000302@sgi.com>
Date: Tue, 26 Feb 2013 09:32:17 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: Add new standard loop handling functions
References: <2102910196.6066385.1360050965047.JavaMail.root@redhat.com>
In-Reply-To: <2102910196.6066385.1360050965047.JavaMail.root@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Add _create_loop_device and _destroy_loop_device to uniformly handle
loopback devices.

Signed-off-by: Tomas Racek <tracek@redhat.com>

>>
>> _create_loop_device()
>> {
>> 	dev=`losetup -f --show $file` || _fail "Cannot associate $file with
>> 	$dev"
>> 	echo $dev
>> }
>>

Looks good.
Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
