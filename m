Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 965837F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 13:08:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7598E8F8052
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 11:08:49 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yefp9E4xowj352Yj for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 11:08:44 -0800 (PST)
Message-ID: <54B56D2B.6090401@sandeen.net>
Date: Tue, 13 Jan 2015 13:08:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com>
	<54B019F4.8030009@sandeen.net>	<20150109182310.GA2785@htj.dyndns.org>	<54B03BCC.7040207@sandeen.net>	<20150110192852.GD25319@htj.dyndns.org>	<54B429EB.9050807@sandeen.net>	<20150112225314.GC22156@htj.dyndns.org>	<54B454E2.70707@sandeen.net>
	<20150112233755.GD22156@htj.dyndns.org>
In-Reply-To: <20150112233755.GD22156@htj.dyndns.org>
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

On 1/12/15 5:37 PM, Tejun Heo wrote:
> Hello, Eric.
> 
> On Mon, Jan 12, 2015 at 05:12:34PM -0600, Eric Sandeen wrote:
>> The only tasks in RU state are the one I mentioned, and swapper/X.
>>
>> crash> ps -m | grep RU
>> [0 00:00:00.159] [RU]  PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
>> [4 19:11:44.360] [RU]  PID: 0      TASK: c0000000010416f0  CPU: 0   COMMAND: "swapper/0"
>> [4 19:11:44.192] [RU]  PID: 0      TASK: c000000633280000  CPU: 1   COMMAND: "swapper/1"
>> [4 19:11:44.192] [RU]  PID: 0      TASK: c0000006332c0000  CPU: 2   COMMAND: "swapper/2"
>> ...
>>
>> and I don't see anything interesting in those. :)
> 
> Heh, I don't get it.  Can you please print out worker_pool->nr_running
> of the pool that the hung work item is queued on?

crash> struct worker_pool c000000001cd7b00
struct worker_pool {
  lock = {
    {
      rlock = {
        raw_lock = {
          slock = 0
        }
      }
    }
  }, 
  cpu = 27, 
  node = 0, 
  id = 54, 
  flags = 0, 
  worklist = {
    next = 0xc0000006182ceee0, 
    prev = 0xc000000000fe0470 <release_agent_work+8>
  }, 
  nr_workers = 15, 
  nr_idle = 0, 
...

And that worklist is the one w/ my stuck aio-stress btree split
worker:

crash> list -H 0xc000000001cd7b18 -o work_struct.entry -s work_struct
...
c00000003ad030a0
struct work_struct {
  data = {
    counter = -4611686018397087739
  }, 
  entry = {
    next = 0xc0000006182c5e08, 
    prev = 0xc0000006182c0750
  }, 
  func = 0xd000000005c58ef0 <xfs_btree_split_worker>
}
...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
