Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1225A7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:29:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1C2630405F
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:29:19 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id McI8gM4cY9xCClY5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 11:29:19 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 26 Apr 2013 14:29:18 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 2C047C90046
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:29:15 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3QITFCw309856 for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:29:15 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r3QITFOj021678 for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 15:29:15 -0300
Subject: Re: xfs module insert fails with "xfs: Unknown symbol
	exportfs_decode_fh (err 0)"
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <517AC13D.9000802@sandeen.net>
References: <1366997050.4098.14.camel@chandra-dt.ibm.com>
	<517AC13D.9000802@sandeen.net>
Date: Fri, 26 Apr 2013 13:29:14 -0500
Message-ID: <1367000954.4098.16.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, 2013-04-26 at 13:02 -0500, Eric Sandeen wrote:
> On 4/26/13 12:24 PM, Chandra Seetharaman wrote:
> > Hello,
> > 
> > When I tried to insert xfs module in my test machine it failed with 
> > 
> > 	xfs: Unknown symbol exportfs_decode_fh (err 0).
> 
> so don't use insmod, use modprobe :)
> 

yup. It is the problem. Config seems to be fine.

false alarm.
> > Found out that I did not have CONFIG_EXPORTFS enabled in my kernel
> > config. 
> 
> Oh, hum. But fs/xfs/Kconfig:
> 
> config XFS_FS
>         tristate "XFS filesystem support"
>         depends on BLOCK
>         select EXPORTFS
> 
> it should be turned on automatically.  That seems to be the problem,
> why wasn't it for your case?
> 
> > All .*by_handle code in XFS is open coded. Wondering if they should be
> > under #ifdef CONFIG_EXPORTFS ?
> 
> CONFIG_EXPORTFS is supposed to be on if xfs is selected, unless something
> changed recently.
> 
> -Eric
> 
> > I can create a patch, but wanted to find out if it is indeed needed :)
> > 
> > Regards,
> > 
> > Chandra
> > 
> > 
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
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
