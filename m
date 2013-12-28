Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99F797F3F
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 16:01:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B0C1AC002
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 14:01:51 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7AhmYIAoXeLzmVbX
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 14:01:50 -0800 (PST)
Message-ID: <52BF4A47.3010604@hardwarefreak.com>
Date: Sat, 28 Dec 2013 16:01:43 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [xfs_check Out of memory: ]
References: <23931797.1848.1388252140769.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <23931797.1848.1388252140769.JavaMail.root@benjamin.baylink.com>
Reply-To: stan@hardwarefreak.com
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
To: Jay Ashworth <jra@baylink.com>, xfs <xfs@oss.sgi.com>

On 12/28/2013 11:35 AM, Jay Ashworth wrote:
> ----- Original Message -----
>> From: "Stan Hoeppner" <stan@hardwarefreak.com>
> 
>> Create a 100GB swap partition and leave the remainder unallocated. The
>> unallocated space will automatically be used for GC and wear leveling,
>> increasing the life of all cells in the drive.
> 
> *Great* tip.  :-)

It's not so much of a tip but simply re-stating common knowledge, or
what should be by now.  Over provisioning of SSDs has been written about
pretty extensively.

One benefit of over provisioning I failed to mention above is that it
also typically decreases the latency and increases the throughput of
random writes significantly.  Linux swap writes tend to be sequential,
so this aspect of over provisioning won't pay dividends for the OP's use
case.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
