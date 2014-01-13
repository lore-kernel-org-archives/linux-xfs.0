Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A0467F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 14:50:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB0EF304043
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:50:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HUXBJhAEFDOAiBIe for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 12:50:01 -0800 (PST)
Message-ID: <52D45178.7020009@sandeen.net>
Date: Mon, 13 Jan 2014 14:50:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel 2.6.22 pdflush consumes ~90% cpu
References: <52D3FF2E.3010901@pace.com>
In-Reply-To: <52D3FF2E.3010901@pace.com>
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
To: Muralitharan Perumal <muralitharan.perumal@pace.com>, xfs@oss.sgi.com

On 1/13/14, 8:58 AM, Muralitharan Perumal wrote:
> Hi,
> 
> I am currently working on an embedded platform involving XFS as the
> preferred fs. Earlier, ext3 was used but now replaced with XFS. The unit
> is working fine with ext3 but after replacing with XFS, I am seeing a
> few issues:

a 7 year old kernel on an embedded platform?  Nobody here will be able
to spend much time on this I'm afraid.

> a) Occassionally I am getting the following error when we write files to
> the fs:
> 
> attempt to access beyond end of device
> sda1: rw=0, want=10487141907480064, limit=9766912
> I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8       ("xfs_trans_read_buf") error 5 buf count 4096
> attempt to access beyond end of device
> sda1: rw=0, want=10487141907480064, limit=9766912
> I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8       ("xfs_trans_read_buf") error 5 buf count 4096

looks like on-disk corruption.  xfs_repair is probably warranted.

> b) After running for about 20 to 25 minutes, the pdflush consumes about 90% cpu and stuck there in D state:

do a sysrq-w to get backtraces of all blocked tasks, and that might yield a clue for you.

-Eric
 
> Is there any similar issue seen with kernel 2.6.22? Am I missing any XFS patches that could fix this?
> 
> Any pointers would be helpful.
> 
> Thanks,
> Murali
> 
> 
> IMPORTANT NOTICE - this e-mail and any attachments hereto are strictly confidential and intended solely for the addressee. If you are not the intended recipient, please notify the sender to report the error and delete this communication immediately. You must not disclose, forward or copy this e-mail or any attachments hereto without the prior consent of the sender.
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
