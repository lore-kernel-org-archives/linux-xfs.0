Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 711E47F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:29:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4FB52304062
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:29:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9KDtWHvT3xMP44vO for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:29:54 -0800 (PST)
Message-ID: <54B58041.9070502@sandeen.net>
Date: Tue, 13 Jan 2015 14:29:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B429EB.9050807@sandeen.net>
	<20150112225314.GC22156@htj.dyndns.org>
	<54B454E2.70707@sandeen.net>
	<20150112233755.GD22156@htj.dyndns.org>
	<54B56D2B.6090401@sandeen.net>
	<20150113201900.GA9489@htj.dyndns.org>
In-Reply-To: <20150113201900.GA9489@htj.dyndns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/13/15 2:19 PM, Tejun Heo wrote:
> Hello, Eric.
> 
> On Tue, Jan 13, 2015 at 01:08:27PM -0600, Eric Sandeen wrote:
>> crash> struct worker_pool c000000001cd7b00
>> struct worker_pool {
>>   lock = {
>>     {
>>       rlock = {
>>         raw_lock = {
>>           slock = 0
>>         }
>>       }
>>     }
>>   }, 
>>   cpu = 27, 
>>   node = 0, 
>>   id = 54, 
>>   flags = 0, 
>>   worklist = {
>>     next = 0xc0000006182ceee0, 
>>     prev = 0xc000000000fe0470 <release_agent_work+8>
>>   }, 
>>   nr_workers = 15, 
>>   nr_idle = 0, 
> 
> Can you please also report the value of nr_running?  That's what
> regulates the kick off of new workers and rescuers.

sorry about that, swapped nr_workers w/ nr_running in my brain:

  nr_running = {
    counter = 0
  }, 

-=Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
