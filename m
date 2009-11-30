Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUEKZ1W017698 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 08:20:35 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: XFS & LVM: unexpected cp when issuing mv
Date: Mon, 30 Nov 2009 08:21:01 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF3C@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <200911301442.20807@zmi.at>
From: "Alex Elder" <aelder@sgi.com>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Montag, 30. November 2009 Dave Chinner wrote:
>>> 1) why this happens
>> 
>> It happens if you move from one project directory heirarchy to
>> another - rename is not allowed across project quota boundaries as
>> the moved data has to be correctly attributed to the new project.
>> Hence it causes a mv to do a copy/unlink by returning a EXDEV error to the rename.
>> 
>>> 2) how I can prevent this?
>> 
>> You can't if you are moving from one project to another. If you
>> move within the project heirarchy, then it will be a rename as per
>> normal.
> 
> Shit. So I have to turn project quotas off. I can't accept the extra
> load for a simple move, as there are tons of data. Maybe the projet code
> could be redesigned to allow a simple move? Is it that complicated?
> 
> If I change from project to user quota - I guess the same would still
> happen? If so, I have to drop quota support, and build a script to check
> quotas manually. It's a pity. :-(

The quota inheritance property Dave described only applies
to project quotas, not group or user quotas.

					-Alex

> mfg zmi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
