Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5QNTfFE008902
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 18:29:41 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A44EA1EE0151
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 16:29:34 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id R6QhvSH4Je3CavQl
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 16:29:34 -0700 (PDT)
Message-ID: <4E07C0DD.6030402@hardwarefreak.com>
Date: Sun, 26 Jun 2011 18:29:33 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br>
	<4E0694CC.8050003@hardwarefreak.com>	<4E06C967.2060107@task.com.br>
	<4E07A41C.1000102@hardwarefreak.com>
In-Reply-To: <4E07A41C.1000102@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marcus Pereira <marcus@task.com.br>
Cc: linux-xfs@oss.sgi.com

On 6/26/2011 4:26 PM, Stan Hoeppner wrote:
> On 6/26/2011 12:53 AM, Marcus Pereira wrote:

>> I got this idea at this post and was giving it a try:
>> http://www.techforce.com.br/news/linux_blog/lvm_raid_xfs_ext3_tuning_for_small_files_parallel_i_o_on_debian
> 
> Did you happen to notice that configuration has an IBM DS8300 SAN head
> with tons of BBWC and *512* fiber channel disks?  You have 8 disks.

The DS8300 has up to 256GB of read/write cache:
http://publib.boulder.ibm.com/infocenter/dsichelp/ds8000ic/index.jsp?topic=%2Fcom.ibm.storage.ssic.help.doc%2Ff2c_ds8300models922and9a2_1w2zq9.html

It's difficult to convey how critical the DS8300, its 8 processor cores,
and its gargantuan cache are in allowing the author to get away with
using so many small XFS allocation groups.  If his storage back end had
consisted of plain HBAs or relatively small cache RAID cards connected
to JBODs w/expanders, using that many small AGs would likely have caused
serious performance degradation instead of a performance increase.

Performance tuning is system specific.  You read a Ferrari tuning manual
and are attempting to apply that to tuning your Volkswagon.  That's
never going to work.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
