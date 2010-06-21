Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5LBWlL3120101 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 06:32:47 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6E60D3EFE07
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 04:35:26 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id lgHj0vEuIjzKSsiF for <xfs@oss.sgi.com>;
	Mon, 21 Jun 2010 04:35:26 -0700 (PDT)
Date: Mon, 21 Jun 2010 13:35:21 +0200
From: Mario Bachmann <grafgrimm77@gmx.de>
Subject: Re: vmalloc, xfs_buf_get: failed to map pages
Message-ID: <20100621133521.4eb1a891@x2.grafnetz>
In-Reply-To: <20100621072118.GA1361@infradead.org>
References: <20100619150119.3ce64102@x2.grafnetz>
	<20100621072118.GA1361@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Am Mon, 21 Jun 2010 03:21:18 -0400
schrieb Christoph Hellwig <hch@infradead.org>:

> On Sat, Jun 19, 2010 at 03:01:19PM +0200, Mario Bachmann wrote:
> > Hello, 
> > 
> > on a 32bit machine, I have big problems with Linux 2.6.34. 
> > With Linux 2.6.33.4 everything runs fine. 
> > 
> > I do not know where to search for known bugs in xfs.
> > 
> > /var/log/messages shows a lot of lines:
> > 
> > Jun 19 11:43:15 amd2000 kernel: vmap allocation for size 4194304 failed: use vmalloc=<size> to increase size.
> > Jun 19 11:43:15 amd2000 kernel: xfs_buf_get: failed to map pages
> > 
> > What to to?
> 
> Strange.  There have been no fixes to the vmap allocator nor to the
> XFS using this.  What other modules are you ising?  Maybe they increased
> their amount of used vmalloc space.  For now the only thing you can do
> is using the vmalloc= kernel paramter to increase the vmalloc space.

What is the command to get all used modules?

Here is the output of the old kernel (2.6.33.4). I used the same kernel-.config for the new kernel (2.6.34):

amd2000 ~ # cat /proc/modules 
sch_sfq 4645 1 - Live 0xf9537000
nfsd 219445 13 - Live 0xf9301000
ipv6 201317 34 - Live 0xf9283000
nf_conntrack_ftp 4780 0 - Live 0xf9238000
nf_conntrack_irc 2587 0 - Live 0xf922d000
ipt_REJECT 1785 2 - Live 0xf8782000
xt_tcpudp 1863 64 - Live 0xf85cc000
nf_conntrack_ipv4 7781 65 - Live 0xf85c0000
nf_defrag_ipv4 747 1 nf_conntrack_ipv4, Live 0xf85b4000
xt_state 919 65 - Live 0xf85ab000
ipt_LOG 4203 12 - Live 0xf8586000
xt_limit 1140 14 - Live 0xf857c000
iptable_filter 1034 1 - Live 0xf84d4000
ipt_addrtype 1449 0 - Live 0xf84ca000
xt_DSCP 1499 0 - Live 0xf84c1000
xt_dscp 1155 0 - Live 0xf84b8000
xt_string 1051 0 - Live 0xf84af000
xt_owner 791 6 - Live 0xf84a6000
xt_NFQUEUE 1565 0 - Live 0xf849d000
xt_multiport 2163 0 - Live 0xf8494000
xt_MARK 597 0 - Live 0xf848a000
xt_mark 597 0 - Live 0xf8481000
xt_iprange 1112 0 - Live 0xf8478000
xt_hashlimit 7490 0 - Live 0xf846e000
xt_conntrack 2183 0 - Live 0xf8462000
xt_CONNMARK 963 0 - Live 0xf8458000
xt_connmark 803 0 - Live 0xf803e000
nf_conntrack 38512 7 nf_conntrack_ftp,nf_conntrack_irc,nf_conntrack_ipv4,xt_state,xt_conntrack,xt_CONNMARK,xt_connmark, Live 0xf843f000
ip_tables 7645 1 iptable_filter, Live 0xf8034000
x_tables 9456 20 ipt_REJECT,xt_tcpudp,xt_state,ipt_LOG,xt_limit,ipt_addrtype,xt_DSCP,xt_dscp,xt_string,xt_owner,xt_NFQUEUE,xt_multiport,xt_MARK,xt_mark,xt_iprange,xt_hashlimit,xt_conntrack,xt_CONNMARK,xt_connmark,ip_tables, Live 0xf800d000
snd_ens1371 13650 0 - Live 0xfa21d000
gameport 6213 1 snd_ens1371, Live 0xfa20d000
snd_rawmidi 14248 1 snd_ens1371, Live 0xfa1fd000
snd_intel8x0 21243 0 - Live 0xfa1e8000
snd_seq_device 4105 1 snd_rawmidi, Live 0xfa1d5000
snd_ac97_codec 85509 2 snd_ens1371,snd_intel8x0, Live 0xfa190000
ac97_bus 702 1 snd_ac97_codec, Live 0xfa166000
snd_pcm 48336 3 snd_ens1371,snd_intel8x0,snd_ac97_codec, Live 0xfa0ef000
snd_timer 14100 1 snd_pcm, Live 0xfa0ca000
nvidia 9829303 0 - Live 0xf9636000 (P)
ppdev 5090 0 - Live 0xf8bdd000
parport_pc 23336 0 - Live 0xf8bbe000
snd 36462 7 snd_ens1371,snd_rawmidi,snd_intel8x0,snd_seq_device,snd_ac97_codec,snd_pcm,snd_timer, Live 0xf8b95000
parport 24435 2 ppdev,parport_pc, Live 0xf8b70000
snd_page_alloc 5345 2 snd_intel8x0,snd_pcm, Live 0xf8012000

What is a good value for vmalloc= ? 
The machine has 1 GB of RAM. 

Mario

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
