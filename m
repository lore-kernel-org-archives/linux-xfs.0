Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C3BCB7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:19:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9590B304064
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:19:07 -0800 (PST)
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com
	[209.85.216.173]) by cuda.sgi.com with ESMTP id
	bCI8Bqt7yxeVs7si (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:19:04 -0800 (PST)
Received: by mail-qc0-f173.google.com with SMTP id i17so4176850qcy.4
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:19:03 -0800 (PST)
Date: Tue, 13 Jan 2015 15:19:00 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150113201900.GA9489@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B429EB.9050807@sandeen.net>
	<20150112225314.GC22156@htj.dyndns.org>
	<54B454E2.70707@sandeen.net>
	<20150112233755.GD22156@htj.dyndns.org>
	<54B56D2B.6090401@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B56D2B.6090401@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hello, Eric.

On Tue, Jan 13, 2015 at 01:08:27PM -0600, Eric Sandeen wrote:
> crash> struct worker_pool c000000001cd7b00
> struct worker_pool {
>   lock = {
>     {
>       rlock = {
>         raw_lock = {
>           slock = 0
>         }
>       }
>     }
>   }, 
>   cpu = 27, 
>   node = 0, 
>   id = 54, 
>   flags = 0, 
>   worklist = {
>     next = 0xc0000006182ceee0, 
>     prev = 0xc000000000fe0470 <release_agent_work+8>
>   }, 
>   nr_workers = 15, 
>   nr_idle = 0, 

Can you please also report the value of nr_running?  That's what
regulates the kick off of new workers and rescuers.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
