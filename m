Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6D437F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 08:13:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96270304105
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 06:13:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xSZTHB8BTcMJFCWb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 06:13:46 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB2EDjPA025144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 2 Dec 2014 09:13:45 -0500
Received: from hades.localdomain (ovpn-113-121.phx2.redhat.com [10.3.113.121])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id sB2EDgLl021400
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 2 Dec 2014 09:13:44 -0500
Date: Tue, 2 Dec 2014 12:13:42 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V8
Message-ID: <20141202141341.GA15157@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: 20141128013830.GA16151@dastard.sgi.com
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
To: xfs@oss.sgi.com

Hi Dave,


>> +			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
>> +						dp1->i_ino, first_block,
>> +						free_list, spaceres);
>> +			if (error)
>> +				goto out;

>now ip2 is modified, so it ctime/mtime dirty.

>> +
>> +			/* transfer target ".." reference to dp1 */
>> +			if (!S_ISDIR(ip1->i_d.di_mode)) {
>> +				error = xfs_droplink(tp, dp2);
>> +				if (error)
>> +					goto out;
>> +				error = xfs_bumplink(tp, dp1);
>> +				if (error)
>> +					goto out;
>> +			}
>> +			xfs_trans_ichgtime(tp, ip1, XFS_ICHGTIME_CHG);
>> +			xfs_trans_ichgtime(tp, ip2,
>> +					   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>> +			xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);

>But now you're unconditionally changing ctime on ip1 without it
>having been modified and you aren't logging the change. Why is the
>ctime changing (comments, please!)?

Ok, so, I can see that I didn't understand what we should do with logging here,
for the moment, I thought we should bump the ip1 to notify userspace that
changes has actually taken place here, even though we are not changing it
anyway. I'm not sure if I should log it too (and add a xfs_trans_log_inode for
ip1). So, should we also log it here together with ip1, or bumping ctime of ip1
here is wrong?
In this case, a more correct way to write it would be to not bump ip1 here but
only in the next block, where we actually touches it?
And regarding dp2 and dp1, we drop/bump its link counts here, should I care
about logging them in this code block? My xfs logging knowledge is shallow by
now :-(

>> +		}
>> +
>> +		if (S_ISDIR(ip1->i_d.di_mode)) {
>> +			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
>> +						dp2->i_ino, first_block,
>> +						free_list, spaceres);
>> +			if (error)
>> +				goto out;

>here ip2 is modified

>> +
>> +			/* transfer src ".." reference to dp2 */
>> +			if (!S_ISDIR(ip2->i_d.di_mode)) {
>> +				error = xfs_droplink(tp, dp1);
>> +				if (error)
>> +					goto out;
>> +				error = xfs_bumplink(tp, dp2);
>> +				if (error)
>> +					goto out;
>> +			}
>> +			xfs_trans_ichgtime(tp, ip1,
>> +					   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>> +			xfs_trans_ichgtime(tp, ip2, XFS_ICHGTIME_CHG);
>> +			xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);

>and same again - changing ctime on ip2 without logging it.

>> +		}
>> +		xfs_trans_ichgtime(tp, dp2,
>> +				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>> +		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
>> +	}
>> +	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>> +	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);

>perhaps:

>	int	ip1_flags = 0;
>	int	ip2_flags = 0;
>	int	dp2_flags = 0;
>
>	if (dp1 != dp2)
>		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>
>		if (S_ISDIR(ip1)) {
>			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>			ip2_flags |= XFS_ICHGTIME_CHG; /* because ... */
>			.....
>		}
>
>		if (S_ISDIR(ip2)) {
>			ip1_flags |= XFS_ICHGTIME_CHG; /* because ... */
>			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>			.....
>		}
>	}
>
>	if (ip1_flags) {
>		xfs_trans_ichgtime(tp, ip1, ip1_flags);
>		xfs_trans_log_inode(tp, ip1);
>	}
>	if (ip2_flags) {
>		xfs_trans_ichgtime(tp, ip2, ip2_flags);
>		xfs_trans_log_inode(tp, ip2);
>	}
>	if (dp2_flags) {
>		xfs_trans_ichgtime(tp, dp2, ip2_flags);
>		xfs_trans_log_inode(tp, dp2);
>	}
>	xfs_trans_ichgtime(tp, dp2, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>	xfs_trans_log_inode(tp, dp2);

I don't think that these extra variables will actually clear the code and make
it more readable IMHO, calling xfs_trans_ichgtime with the flags directly looks
more clear and readable to me.

Thanks for the review,
I have fixed all the another points you mentioned now, I think that handling log
correct on the above snippet is the last thing to do by now.

cheers.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
