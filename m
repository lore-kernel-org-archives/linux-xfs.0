Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 05:56:17 -0700 (PDT)
Received: from outfbmx008.isp.belgacom.be (outfbmx008.isp.belgacom.be [195.238.5.105])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77Cu1DW026545
	for <linux-xfs@oss.sgi.com>; Mon, 7 Aug 2006 05:56:02 -0700
Received: from outmx009.isp.belgacom.be (outmx009.isp.belgacom.be [195.238.5.4])
	by outfbmx008.isp.belgacom.be (Postfix) with ESMTP id 72FC639937
	for <linux-xfs@oss.sgi.com>; Mon,  7 Aug 2006 13:02:19 +0200 (CEST)
Received: from outmx009.isp.belgacom.be (localhost [127.0.0.1])
        by outmx009.isp.belgacom.be (8.12.11.20060308/8.12.11/Skynet-OUT-2.22) with ESMTP id k77B1ndr024944
        for <linux-xfs@oss.sgi.com>; Mon, 7 Aug 2006 13:01:49 +0200
        (envelope-from <kris.buggenhout@skynet.be>)
Message-ID: <44D71DA2.2020409@skynet.be>
Date: Mon, 07 Aug 2006 13:01:54 +0200
From: kris buggenhout <kris.buggenhout@skynet.be>
MIME-Version: 1.0
Subject: Re: Concurrent mount of XFS over SAN
References: <44D26D3E.5010708@exegy.com> <20060807084830.58133.qmail@web31713.mail.mud.yahoo.com> <slrnede4hl.bg1.mykleb@99RXZYP.ibm.com>
In-Reply-To: <slrnede4hl.bg1.mykleb@99RXZYP.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan-Frode Myklebust <mykleb@no.ibm.com>
Cc: linux-xfs@oss.sgi.com

afaik, the node was stored in xlv, which was an extra option in IRIX, ( 
extra license) but this could later be used in CXFS which allows 
multiple machines to mount the same FS read write from a SAN, made for 
clusters, HA and HPC...

knowledge of the node "owning" the device was in there for protection. 
but can be overridden with an xlv command.

kind regards, Kris

Jan-Frode Myklebust wrote:
> On 2006-08-07, Heilige Gheist <hgheist@yahoo.com> wrote:
>   
>> It's obvious that I can always fall back to the inter-node heart-beat
>> to ensure that only one node is mounting the filesystem.
>> I'm just wondering if there's any facility or accepted practice to
>> enforce it.
>>     
>
> STONITH (Shoot The Other Node In The Head) trough smart power switches
> or management adapters in the node. 
>
> SCSI reserve/release ... No idea how reliable this is on a SAN, but the
> ServeRAID-version works great. http://www.linux-ha.org/ServeRAID
>
> Export the volume group, or scsi device on the first node, before
> importing/attaching it on the second .. Probably best to use together
> with STONITH, in case the first node fails on unmounting/exporting.
>
> BTW: I think XFS on IRIX had the owning node name in the file system header, 
> and only would allow this node to mount the fs. But I can't find this now...
> Maybe it's gone, or maybe it was in xlv.. ?
>
>
>   -jf
>
>
>
>
>   
