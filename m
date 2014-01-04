Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6944E7F50
	for <xfs@oss.sgi.com>; Sat,  4 Jan 2014 09:45:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 383008F8040
	for <xfs@oss.sgi.com>; Sat,  4 Jan 2014 07:45:12 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 3LARRAG6bTXPyh64
	for <xfs@oss.sgi.com>; Sat, 04 Jan 2014 07:45:11 -0800 (PST)
Message-ID: <52C82C82.8020801@hardwarefreak.com>
Date: Sat, 04 Jan 2014 09:45:06 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS File System Monitor
References: <CA+apj_hV4HvZxfASF7JJ1k6mmvio3cRWAHj-S1V=Vm8X_RWA=Q@mail.gmail.com>	<52C58095.70408@hardwarefreak.com>
	<CA+apj_iOy2dqyPGunKe91WLCqy71uE1uq2HZQ_v=+QHewCymeA@mail.gmail.com>
In-Reply-To: <CA+apj_iOy2dqyPGunKe91WLCqy71uE1uq2HZQ_v=+QHewCymeA@mail.gmail.com>
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
To: Rotem Ben Arye <rotem.benarye@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/4/2014 2:21 AM, Rotem Ben Arye wrote:
> Hi Stan,
> Thank you for focused answer ,only to realize , i'm aware that monitor snmp
> checks On  /var/log/messages
> Of Production server in power failure ,so that after that will tell us -
> "power outage causes to a file system corruption" is useless.
> 
> But for all those cases that you mention " bugs in the XFS code or
> elsewhere in the Linux kernel , transient or permanent hardware failures"
> Is there no some suitable log that we can track to get an indication of
> kind event that you specified .

Errors due to such problems are logged in dmesg.  Hardware problems will
usually show up as IO errors generated from the device on which XFS
resides.  When these occur XFS will typically initiate automatic
shutdown of the filesystem to prevent (further) corruption.  In this
case the log entry occurs simultaneously with the shutdown, so
monitoring logs won't notify you in advance of this problem.  Monitoring
your hardware may.

If you get corruption due to a software bug, you may not see an error in
the log until after the filesystem suffers the corruption event.
Usually when you see errors of this nature in the log it is because
corruption has already occurred, possibly long ago, but is just now
being detected by code specifically added to XFS to detect such things.
 For example, say your filesystem is 3 years old, corruption occurred in
year one, and an update to XFS 2 years later looks for such corruption
whereas before it did not.  Depending on the severity of the corruption,
xfs_repair may be able to fix it, or it may not.  If not you ask for
help here.

So again, I'm not away of any proactive monitoring that would help in
these situations.  Of course it would be nice to know if something is
going to fail beforehand, but this isn't always possible, unfortunately.

--
Stan


> Thank you.
> 
> 
> 
> On Thu, Jan 2, 2014 at 5:07 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:
> 
>> On 1/2/2014 6:16 AM, Rotem Ben Arye wrote:
>>> Hi, SGI Support Team.
>>> My Name is Rotem , I am a Linux/Unix System Administrator in web company
>> at
>>> Israel.
>>> I have a question I want to appeal to you to get some advice.
>>>
>>> In the last weekend we had crisis in one of the Production server in
>>> the comany ,the problem was defined by the Integrators as  "xfs file
>> system
>>> corrupted"
>>> My question is , what are the open source tools , that we can use on
>>> runtime at production environment , to monitor and sample to get
>> indication
>>> on mount XFS ,
>>> That something is not living well, and can lead to problem.
>>>
>>> We are working in a Linux environment on CentOS distributions server.
>>
>> So in a nutshell you're looking for a monitor application that will in
>> essence give you a green, yellow, or red light informing you of the
>> filesystem's health.  Or some kind of SNMP logging that suggests a
>> corruption is imminent.
>>
>> There is no such tool, and never will be.  Nearly all XFS corruption
>> events are caused by either software bugs in the XFS code or elsewhere
>> in the Linux kernel, transient or permanent hardware failures, or power
>> failures, at some layer in the storage stack.  It is not feasible to
>> predict such events.
>>
>> When an XFS corruption occurs, one should report all related log
>> information and errors to this list so that the problem may be analyzed
>> and the root cause identified.  Then the proper corrective action can be
>> identified and implemented to fix the problem and hopefully prevent it
>> from reoccurring.
>>
>> --
>> Stan
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
